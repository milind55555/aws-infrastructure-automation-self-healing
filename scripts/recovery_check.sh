#!/usr/bin/env bash
set -euo pipefail
URL="${1:-http://127.0.0.1:5000/health}"
echo "Checking health endpoint: $URL"
for attempt in $(seq 1 10); do
  if curl --fail --silent --show-error "$URL"; then
    echo
    echo "Health check passed."
    exit 0
  fi
  echo "Attempt $attempt failed; retrying..."
  sleep 2
done
echo "Health check failed after retries." >&2
exit 1
