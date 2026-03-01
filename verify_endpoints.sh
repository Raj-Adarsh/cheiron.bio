#!/bin/bash
set -e

# Usage: ./verify_endpoints.sh <alb_dns>

HOST=${1:?"Usage: $0 <alb_dns>"}

fail() {
  echo "[FAIL] $1"
  exit 1
}

check() {
  local url=$1
  local expect=$2
  local msg=$3
  resp=$(curl -fsS "$url" || true)
  echo "[RESPONSE] $url => $resp"
  echo "$resp" | grep -q "$expect" || fail "$msg"
}

# service_a endpoints
check "http://$HOST/service_a/health" "service_a" "/service_a/healthz failed"
check "http://$HOST/service_a/api/ping" "service_a" "/service_a/api/ping failed"

# service_b endpoints
check "http://$HOST/service_b/health" "service_b" "/service_b/healthz failed"
check "http://$HOST/service_b/api/ping" "service_b" "/service_b/api/ping failed"

echo "[PASS] All checks passed for service_a and service_b on $HOST"
exit 0
