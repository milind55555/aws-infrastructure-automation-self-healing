# AWS Infrastructure Automation and Self-Healing Platform

A portfolio-ready DevOps project demonstrating repeatable AWS infrastructure provisioning, configuration management, container deployment, monitoring, automated recovery, and incident runbooks.

> **Important:** This repository is a working starter/reference implementation. It has not been deployed or tested in your AWS account. Review costs, region-specific settings, IAM permissions, and security controls before applying. The Terraform and CloudFormation examples are alternatives for provisioning the same baseline; **do not deploy both into the same environment**.

## Architecture

```text
Developer
   |
   v
GitHub -> Jenkins pipeline -> tests / Docker build / image scan
                                  |
                                  v
                           Container registry
                                  |
                                  v
Internet -> ALB -> Auto Scaling Group (EC2 + Docker)
                         |                |
                         |                +--> Containerized Flask health API
                         |
                         +--> CloudWatch metrics, alarms, SNS notifications
                                      |
                                      +--> EC2 recovery / ASG replacement
```

Kubernetes manifests are included as an optional deployment path for a Kubernetes cluster you already operate. The primary AWS infrastructure example uses EC2 + Auto Scaling to keep the self-healing flow understandable and cost-conscious.

## Technology stack

- AWS: VPC, public/private subnets, Internet Gateway, NAT Gateway (optional), ALB, EC2 Auto Scaling, IAM, CloudWatch, SNS
- Infrastructure as Code: Terraform **or** AWS CloudFormation
- Configuration management: Chef cookbook and recipe
- Containers: Docker
- Orchestration option: Kubernetes manifests
- CI/CD: Jenkins
- Automation: Python and Bash

## Repository map

```text
.
├── app/                         # Flask service with health endpoint and tests
├── docker/                      # Dockerfile and .dockerignore
├── terraform/                   # Modular-style AWS baseline
├── cloudformation/              # Alternative AWS baseline template
├── chef/                        # Chef cookbook / recipe / attributes
├── kubernetes/                  # Optional Deployment + Service manifests
├── jenkins/                     # Jenkins pipeline
├── scripts/                     # Validation, failure simulation, recovery helper
├── docs/                         # Architecture, operations, troubleshooting
└── .github/workflows/           # GitHub Actions checks
```

## Quick start: run the app locally

Requirements: Python 3.11+ or Docker.

```bash
cd app
python -m venv .venv
# Windows: .venv\Scripts\activate
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000/health`. Run tests with `pytest`.

Using Docker:

```bash
docker build -f docker/Dockerfile -t self-healing-demo:local .
docker run --rm -p 5000:5000 self-healing-demo:local
```

## Deploy with Terraform

Prerequisites: AWS CLI configured, Terraform 1.6+, an AWS account, and a deployment region. Review `terraform/variables.tf` and `docs/security-and-cost.md`.

```bash
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
# Inspect the plan before proceeding:
terraform apply tfplan
```

The Terraform example provisions a VPC, two public subnets, an ALB, a launch template, an Auto Scaling Group, security groups, and CloudWatch alarms. It uses an Amazon Linux 2023 AMI resolved through SSM and installs Docker plus the demo app via user data. For a production system, move app deployment to a controlled image registry and use private subnets with NAT or VPC endpoints; this demo keeps the baseline simpler to make it easier to learn.

To tear down after reviewing the environment:

```bash
terraform destroy
```

Do not destroy shared or production infrastructure. Check for resources not managed by Terraform before cleanup.

## Deploy with CloudFormation (alternative)

```bash
aws cloudformation validate-template --template-body file://cloudformation/template.yaml
aws cloudformation create-stack \
  --stack-name self-healing-demo \
  --template-body file://cloudformation/template.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters ParameterKey=ProjectName,ParameterValue=self-healing-demo
```

Check stack events and outputs before testing. Delete the stack when finished:

```bash
aws cloudformation delete-stack --stack-name self-healing-demo
```

The CloudFormation file is an alternative baseline, not a second layer to apply on top of Terraform.

## CI/CD with Jenkins

1. Install Jenkins with Docker CLI available to the agent, or use a dedicated Docker-capable build agent.
2. Configure credentials only in Jenkins Credentials (never commit keys).
3. Create a Pipeline job from this repository.
4. `Jenkinsfile` runs Python tests, builds the image, and optionally pushes it when registry credentials and environment variables are configured.
5. Set `IMAGE_REPOSITORY` and `IMAGE_TAG` as job environment variables. For a private registry, authenticate using Jenkins credentials and adjust the pipeline stage to your registry.

The default pipeline intentionally does not deploy to a live AWS account. Add a protected deployment stage after configuring least-privilege AWS credentials, environment approvals, and image provenance checks.

## Optional Kubernetes path

`kubernetes/` includes a Deployment, Service, and NetworkPolicy starter. Update the image field to your registry image, then:

```bash
kubectl apply -f kubernetes/
kubectl rollout status deployment/self-healing-demo
kubectl get pods,svc
```

The Service is ClusterIP by default. Expose it through an ingress/controller or a cloud load balancer only after configuring authentication, TLS, and network controls. The included manifests are not an EKS cluster provisioner.

## Self-healing demo

The primary recovery pattern is:
- ALB health checks stop routing to unhealthy targets.
- Auto Scaling replaces unhealthy EC2 instances when EC2/ELB health checks are enabled.
- CloudWatch alarms notify an SNS topic when CPU is high or target health is low.
- Runbook steps guide diagnosis, mitigation, and rollback.

Run `scripts/simulate_failure.sh` only against a test deployment you own. It can stop the demo container locally; it does not intentionally terminate AWS resources. `scripts/recovery_check.sh` checks the local health endpoint.

## Security notes

- Never commit AWS keys, registry tokens, SSH private keys, `.tfstate`, or plan files.
- Use IAM roles instead of long-lived credentials.
- Restrict SSH ingress; default Terraform security group intentionally does not open SSH.
- The demo uses public subnets and user data for clarity. For production, prefer private application subnets, managed secrets, TLS, immutable image tags, hardened AMIs, and VPC endpoints/NAT as appropriate.
- Pin action/plugin/provider versions and review security advisories before production use.

## Resume bullets (adapt only after you have run and verified the project)

- Built an AWS infrastructure automation platform using Terraform and CloudFormation to provision network, load balancing, compute scaling, and monitoring resources through repeatable IaC workflows.
- Containerized a Flask health API with Docker and added Jenkins CI stages for automated tests and image builds.
- Implemented operational recovery patterns using ALB health checks, EC2 Auto Scaling, CloudWatch alarms, and documented incident runbooks.
- Added Chef configuration recipes and optional Kubernetes manifests to demonstrate configuration management and container orchestration.

Do not claim production deployment, uptime improvements, or cost savings until measured and verified.
