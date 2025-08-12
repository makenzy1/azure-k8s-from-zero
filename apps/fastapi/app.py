from fastapi import FastAPI
import time
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
start = time.time()

Instrumentator().instrument(app).expose(app)

@app.get("/")
def root():
    return {"hello": "world", "uptime_seconds": round(time.time() - start, 2)}

@app.get("/healthz")
def healthz():
    return {"status": "ok"}
