# Phase 4 — GitOps with Argo CD

```bash
make argocd-install
kubectl -n argocd port-forward svc/argocd-server 8080:80 &
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```
Edit `app-of-apps.yaml` and `apps/sample-app.yaml` to point to **your** Git repo, then:
```bash
make gitops-bootstrap
```
