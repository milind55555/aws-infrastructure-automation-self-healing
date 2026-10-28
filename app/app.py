from flask import Flask, jsonify
import os
import time

app = Flask(__name__)
START_TIME = time.time()

@app.get("/")
def index():
    return jsonify(
        service="self-healing-demo",
        status="ok",
        message="AWS Infrastructure Automation and Self-Healing Platform demo"
    )

@app.get("/health")
def health():
    return jsonify(status="healthy", uptime_seconds=round(time.time() - START_TIME, 2)), 200

@app.get("/ready")
def ready():
    # Replace with real dependency checks when adding a database or queue.
    return jsonify(ready=True), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "5000")))
