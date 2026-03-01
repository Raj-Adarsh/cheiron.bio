#!/bin/bash
set -e

# Usage: ./verify_services.sh <host> <port> <service_name>
# Example: ./verify_services.sh localhost 8080 service_a

HOST=${1:-localhost}
PORT=${2:-8080}
SERVICE=${3:-service_a}

fail() {
  echo "[FAIL] $1"
  exit 1
}

check() {
  local url=$1
  local expect=$2
  local msg=$3
  resp=$(curl -fsS "$url" || true)
  echo "$resp" | grep -q "$expect" || fail "$msg"
}

# /healthz endpoint
check "http://$HOST:$PORT/healthz" "$SERVICE" "/healthz endpoint failed for $SERVICE"

# /api/ping endpoint
check "http://$HOST:$PORT/api/ping" "$SERVICE" "/api/ping endpoint failed for $SERVICE"

echo "[PASS] All checks passed for $SERVICE on $HOST:$PORT"
exit 0
