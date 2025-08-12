# Phase 7 — BentoML (Iris)

```bash
make ml-train
make ml-build
make ml-push      # requires REGISTRY set & docker login
make ml-deploy
```
Update `ml/bentoml/k8s/deployment.yaml` image to your repo.
