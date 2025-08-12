# Phase 0 — Self-Hosting & Tunnels

Run app locally and expose:
```bash
cd apps/fastapi
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app:app --reload --port 8080
```

SSH reverse tunnel:
```bash
ssh -N -R 8080:localhost:8080 user@your-vps
```

frp configs in `tunnels/frp/`, ngrok config in `tunnels/ngrok/ngrok.yml`, inlets notes at https://inlets.dev/
