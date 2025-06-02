variable "name_prefix" {}
variable "ami_id" {}
variable "instance_type" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "subnet_ids" {
  type = list(string)
}
