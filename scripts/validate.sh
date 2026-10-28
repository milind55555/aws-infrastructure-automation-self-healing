#!/usr/bin/env bash
set -euo pipefail
echo '[1/3] Python tests'
python3 -m pip install -r app/requirements-dev.txt
pytest -q app
echo '[2/3] Docker build'
docker build -f docker/Dockerfile -t self-healing-demo:validation .
echo '[3/3] Terraform format (if Terraform is installed)'
if command -v terraform >/dev/null 2>&1; then
  terraform -chdir=terraform fmt -check
else
  echo 'Terraform not installed; skipped.'
fi
echo 'Validation checks completed.'
