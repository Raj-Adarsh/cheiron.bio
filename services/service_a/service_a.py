
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/healthz')
def healthz():
    return jsonify(status="ok", service="service_a"), 200

@app.route('/api/ping')
def ping():
    return jsonify(message="pong from service_a"), 200

if __name__ == "__main__":
    import os
    port = int(os.environ.get("APP_PORT", 8080))
    app.run(host="0.0.0.0", port=port)
