# Security and cost checklist

## Before applying infrastructure

- [ ] Use a dedicated sandbox AWS account or approved development environment.
- [ ] Confirm region, quotas, and estimated costs.
- [ ] Restrict `allowed_http_cidr` to your IP/CIDR when possible.
- [ ] Do not open SSH (no SSH ingress rule is included).
- [ ] Use a least-privilege IAM role and review the attached SSM policy.
- [ ] Enable billing alerts and set a budget.
- [ ] Avoid committing state files, credentials, private keys, or `.env` files.

## Cost considerations

The ALB, EC2 instances, data transfer, public IPv4 addresses, and CloudWatch usage may incur charges. A NAT Gateway can add meaningful hourly and data processing costs, so it is not included in the baseline. Destroy the stack when finished and verify resources in the AWS console afterward.

## Production security improvements

- HTTPS/TLS with ACM and secure headers.
- Private application subnets and restricted egress.
- ECR image scanning, immutable tags, SBOM generation, and signature verification.
- Secret Manager or Parameter Store for runtime secrets.
- CloudTrail, Config, GuardDuty, centralized logs, and alert routing.
- Protected branches, code review, pinned actions, and separate deployment roles.
