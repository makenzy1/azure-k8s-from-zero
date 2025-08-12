# from sklearn.datasets import load_iris
# from sklearn.ensemble import RandomForestClassifier
# from sklearn.model_selection import train_test_split
# import bentoml

# X, y = load_iris(return_X_y=True)
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
# clf = RandomForestClassifier(n_estimators=100, random_state=42).fit(X_train, y_train)
# print("Accuracy:", clf.score(X_test, y_test))
# bentoml.sklearn.save_model("iris_rf:latest", clf)
# print("Saved iris_rf model.")

# ml/bentoml/train.py
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import bentoml
import os
from datetime import datetime

X, y = load_iris(return_X_y=True)
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

clf = RandomForestClassifier(n_estimators=100, random_state=42).fit(X_train, y_train)
print("Accuracy:", clf.score(X_test, y_test))

model_version = os.getenv("MODEL_VERSION")
if not model_version:
    sha = os.getenv("GITHUB_SHA")
    model_version = (sha[:7] if sha else datetime.utcnow().strftime("%Y%m%d%H%M%S"))

tag = f"iris_rf:{model_version}"
bentoml.sklearn.save_model(tag, clf)
print("Saved model tag:", tag)
