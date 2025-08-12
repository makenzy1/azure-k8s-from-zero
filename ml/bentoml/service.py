import numpy as np
import bentoml
from bentoml.io import JSON
from prometheus_client import Counter

model = bentoml.sklearn.get("iris_rf:latest")
runner = model.to_runner()
svc = bentoml.Service("service", runners=[runner])

PRED_COUNT = Counter("predictions_total", "Total prediction requests")

@svc.api(input=JSON(), output=JSON())
async def classify(json: dict):
    PRED_COUNT.inc()
    import numpy as np
    data = np.array(json["instances"], dtype=float)
    result = await runner.run(data)
    return {"predictions": result.tolist()}
