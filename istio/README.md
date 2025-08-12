# Phase 5 — Istio

```bash
make istio-install
kubectl -n istio-system port-forward svc/istio-ingressgateway 8081:80 &
kubectl apply -f istio/gateway.yaml
kubectl apply -f istio/virtualservice.yaml
```
Open http://localhost:8081/
