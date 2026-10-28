#!/usr/bin/env bash
# Local-only demo. This script stops a Docker container; it does not terminate AWS resources.
set -euo pipefail
CONTAINER="${1:-self-healing-demo}"
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required." >&2
  exit 1
fi
if ! docker inspect "$CONTAINER" >/dev/null 2>&1; then
  echo "Container '$CONTAINER' does not exist. Start it first." >&2
  exit 1
fi
echo "Stopping local container '$CONTAINER' to simulate a service failure..."
docker stop "$CONTAINER"
echo "Failure simulated. Restart it with: docker start $CONTAINER"
