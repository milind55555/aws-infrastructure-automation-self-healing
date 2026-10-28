# Architecture and design decisions

## Primary AWS path

- **VPC:** isolated address space for the demo.
- **Public subnets:** host the internet-facing ALB and, for simplicity in this learning baseline, EC2 application instances.
- **ALB + target group:** sends HTTP traffic to instances on TCP/5000 and checks `/health`.
- **Launch template + Auto Scaling Group:** creates repeatable instances and replaces instances marked unhealthy by ELB health checks.
- **IAM instance profile + SSM policy:** supports Systems Manager management without opening SSH.
- **CloudWatch + SNS:** alarm on high EC2 CPU and unhealthy ALB targets, with optional email notification.

## Self-healing boundaries

Auto Scaling can replace an unhealthy instance when ELB health checks are enabled. The service's local systemd unit also restarts a crashed process. These are different recovery layers:
1. Process restart on the same VM.
2. ALB stops routing to a bad target.
3. Auto Scaling replaces an unhealthy instance.
4. CloudWatch/SNS informs an operator of sustained symptoms.

An alarm does not automatically fix every issue. Use runbooks and incident evidence to identify root cause.

## Production hardening backlog

- Move application instances into private subnets; use NAT Gateway or VPC endpoints for required outbound access.
- Add HTTPS listener and ACM certificate; redirect HTTP to HTTPS.
- Pull a pinned immutable image from ECR instead of building app code in user data.
- Add WAF, access logging, centralized application logs, tracing, and dashboards.
- Add autoscaling policies based on ALB request count/CPU and test capacity behavior.
- Use remote Terraform state with encryption, locking, and restricted access.
- Separate environments/accounts and use approvals for production changes.
