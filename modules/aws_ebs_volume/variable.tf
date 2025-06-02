variable "availability_zone" {}
variable "size" {
  default = 8
}
variable "volume_type" {
  default = "gp2"
}
variable "name" {
  default = "my-ebs-volume"
}
