output "load_balancer_url" {
  description = "HTTP endpoint for the demo app."
  value       = "http://${aws_lb.app.dns_name}"
}
output "vpc_id" { value = aws_vpc.main.id }
output "autoscaling_group_name" { value = aws_autoscaling_group.app.name }
output "sns_topic_arn" { value = aws_sns_topic.alerts.arn }
