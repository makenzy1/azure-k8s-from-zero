# Phase 2 — Local Kubernetes (kind)

```bash
kind create cluster --config kind-cluster.yaml
kubectl apply -k overlays/dev
kubectl -n apps get deploy,svc,ing
```
Access via http://fastapi.localtest.me
