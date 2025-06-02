variable "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
}

variable "retention_days" {
  description = "Retention days for log group"
  type        = number
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}