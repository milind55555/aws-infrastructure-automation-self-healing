# Operations runbook

## 1. ALB target is unhealthy

**Symptoms:** ALB returns 5xx/timeouts or target group shows unhealthy targets.

1. Confirm the ALB URL and target group health.
2. Check instance status checks and Auto Scaling activity history.
3. Connect through AWS Systems Manager Session Manager (do not open SSH broadly).
4. Inspect service: `sudo systemctl status self-healing-demo`.
5. Inspect logs: `sudo journalctl -u self-healing-demo --since '30 minutes ago'`.
6. Check port/listener/security-group path: ALB SG permits 80; app SG permits 5000 only from ALB SG.
7. If the instance is irrecoverable, let Auto Scaling replace it or terminate only a disposable demo instance after confirming ASG health checks.
8. Record timestamp, instance ID, target health reason, logs, action, and recovery time.

## 2. High CPU alarm

1. Confirm alarm state and graph period.
2. Inspect CloudWatch CPU metrics and ASG desired/in-service capacity.
3. Review application logs and recent deployment changes.
4. Check for traffic spikes or repeated restarts.
5. Scale only within approved capacity and budget.
6. Roll back the last known bad artifact if symptoms started after deployment.
7. Capture root cause and follow-up action.

## 3. Deployment failed

1. Stop promotion; do not deploy further environments.
2. Identify failing stage (tests, build, registry, rollout).
3. Preserve logs and image digest.
4. Re-deploy last known good immutable image/tag.
5. Verify `/health` and `/ready`, error rate, and target health.
6. Open a follow-up issue with cause and preventive test.

## 4. Recovery verification

```bash
./scripts/recovery_check.sh http://YOUR-ALB-DNS/health
```

A successful response means the endpoint is responding; it does not by itself prove all dependencies or business flows are healthy.
