# variable "trail_name" {}
# variable "s3_bucket_name" {}
# variable "account_id" {}

resource "aws_cloudtrail" "this" {
  name                          = var.trail_name
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
