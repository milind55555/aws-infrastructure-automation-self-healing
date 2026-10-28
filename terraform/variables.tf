variable "aws_region" {
  description = "AWS region for this demo."
  type        = string
  default     = "ap-south-1"
}
variable "project_name" {
  description = "Short name used in resource names."
  type        = string
  default     = "self-healing-demo"
}
variable "instance_type" {
  description = "EC2 instance type; review regional pricing before deployment."
  type        = string
  default     = "t3.micro"
}
variable "allowed_http_cidr" {
  description = "CIDR allowed to access the demo ALB. Restrict this for non-demo environments."
  type        = string
  default     = "0.0.0.0/0"
}
variable "min_size" {
  type    = number
  default = 1
}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 3
}
variable "notification_email" {
  description = "Optional email endpoint for SNS alarms; leave blank to disable subscription."
  type        = string
  default     = ""
}
