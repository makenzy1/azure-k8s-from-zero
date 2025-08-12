SHELL := /bin/bash

REGISTRY ?= docker.io/your-username
APP_IMAGE ?= $(REGISTRY)/fastapi-sample:latest
ML_IMAGE ?= $(REGISTRY)/bento-iris:latest

# ---------- kind ----------
kind-up:
	kind create cluster --config kind/kind-cluster.yaml || true
	kubectl cluster-info && kubectl get nodes

kind-down:
	kind delete cluster || true

# ---------- Sample App ----------
app-build:
	docker build -t $(APP_IMAGE) apps/fastapi

app-push:
	docker push $(APP_IMAGE)

app-deploy:
	kubectl apply -k kind/overlays/dev

# ---------- Argo CD ----------
argocd-install:
	kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update
	helm upgrade --install argocd argo/argo-cd -n argocd \
		--set configs.params.server\.insecure=true
	kubectl -n argocd rollout status deploy/argocd-server

gitops-bootstrap:
	kubectl apply -n argocd -f gitops/argocd/app-of-apps.yaml

# ---------- Istio ----------
istio-install:
	istioctl install -y --set profile=demo
	kubectl create ns apps --dry-run=client -o yaml | kubectl apply -f -
	kubectl label ns apps istio-injection=enabled --overwrite=true

# ---------- Observability ----------
observability-install:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update
	helm upgrade --install kube-prom prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f observability/values-kube-prometheus-stack.yaml
	helm upgrade --install loki grafana/loki-stack -n monitoring -f observability/values-loki.yaml
	kubectl apply -f observability/servicemonitor-fastapi.yaml || true

# ---------- ML with BentoML ----------
ml-train:
	cd ml/bentoml && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && python train.py

ml-build:
	cd ml/bentoml && source .venv/bin/activate && bentoml build && bentoml containerize service:latest -t $(ML_IMAGE)

ml-push:
	docker push $(ML_IMAGE)

ml-deploy:
	kubectl apply -f ml/bentoml/k8s/deployment.yaml
	kubectl apply -f ml/bentoml/k8s/hpa.yaml
	kubectl apply -f ml/bentoml/k8s/servicemonitor.yaml || true

.PHONY: kind-up kind-down app-build app-push app-deploy argocd-install gitops-bootstrap istio-install observability-install ml-train ml-build ml-push ml-deploy
