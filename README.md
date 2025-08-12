# Azure Kubernetes — From Zero (Hands-on Project)

Learn Kubernetes by doing: self-host on a VM → local kind cluster → real kubeadm cluster on Azure VMs → GitOps (Argo CD) → Istio → Observability → ML model serving (BentoML). Each phase has exact commands.

---

## Phases

0. **Self-Hosting & Tunnels** — expose a local FastAPI app via SSH reverse tunnels, frp, ngrok, inlets. → [`tunnels/`](tunnels/README.md)  
1. **Manual Azure VM** — Ubuntu VM: users, firewall, nginx/Caddy, systemd, Certbot. → [`azure-vm/`](azure-vm/README.md)  
2. **Local Kubernetes (kind)** — multi-node kind cluster + Kustomize. → [`kind/`](kind/README.md)  
3. **Real Cluster with kubeadm (Azure VMs)** — control-plane + workers + Calico CNI. → [`kubeadm/`](kubeadm/README.md)  
4. **GitOps with Argo CD** — App-of-Apps; Git drives cluster state. → [`gitops/argocd/`](gitops/argocd/README.md)  
5. **Istio Service Mesh** — ingress gateway + virtual service. → [`istio/`](istio/README.md)  
6. **Observability** — kube-prometheus-stack + Loki, SLO alerts. → [`observability/`](observability/README.md)  
7. **Serve ML Model** — BentoML iris demo, HPA, metrics. → [`ml/bentoml/`](ml/bentoml/README.md)

A **Makefile** provides shortcuts.

---

## Prerequisites

- `git`, `docker`, `kubectl`, `helm`, `jq`, `yq`, `make`, `python3`
- Docker Desktop (or containerd + Docker CLI) for local builds
- Azure CLI (`az`) and an Azure subscription
- Docker Hub account (or ACR)

Set your registry:
```bash
export REGISTRY=docker.io/your-username
```

## Quick start (local)

```bash
make kind-up
make app-deploy
make argocd-install
kubectl -n argocd port-forward svc/argocd-server 8080:80 &
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
make istio-install
make gitops-bootstrap
make observability-install
make ml-train && make ml-build && make ml-push && make ml-deploy
```

---

## GitHub Actions (Docker Hub)

Two workflows are included:

- `.github/workflows/fastapi-dockerhub.yml` — builds and pushes `fastapi-sample` on changes to `apps/fastapi/**`
- `.github/workflows/bentoml-dockerhub.yml` — trains, builds, containerizes, and pushes `bento-iris`

Add **Repository secrets** in GitHub:
- `DOCKERHUB_USERNAME` — your Docker Hub username (e.g., `macpherson03`)
- `DOCKERHUB_TOKEN` — a Docker Hub **Access Token** (create at https://hub.docker.com/settings/security)

Update Kubernetes images after your first push:
- `docker.io/<DOCKERHUB_USERNAME>/fastapi-sample:latest`
- `docker.io/<DOCKERHUB_USERNAME>/bento-iris:latest`
