
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health')
def health():
	return jsonify(status="ok", service="service_b"), 200

@app.route('/api/ping')
def ping():
	return jsonify(message="pong from service_b"), 200

# Add prefixed routes for ALB path-based routing
@app.route('/service_b/health')
def service_b_healthz():
    return health()

@app.route('/service_b/api/ping')
def service_b_ping():
    return ping()

if __name__ == "__main__":
	import os
	port = int(os.environ.get("APP_PORT", 8080))
	app.run(host="0.0.0.0", port=port)
