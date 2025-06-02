variable "name_prefix" {}
variable "node_type" {}
variable "num_nodes" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
