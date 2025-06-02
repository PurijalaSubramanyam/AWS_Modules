variable "alarm_name" {}
variable "comparison_operator" {
  default = "GreaterThanThreshold"
}
variable "evaluation_periods" {
  default = 2
}
variable "metric_name" {}
variable "namespace" {}
variable "period" {
  default = 300
}
variable "statistic" {
  default = "Average"
}
variable "threshold" {}
variable "alarm_description" {
  default = "Alarm when threshold is breached"
}
variable "actions_enabled" {
  default = false
}
variable "dimensions" {
  type = map(string)
}
variable "alarm_actions" {
  type    = list(string)
  default = []
}
