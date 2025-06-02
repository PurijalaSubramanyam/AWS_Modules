variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "cluster_role_arn" {}

variable "subnet_ids" {
  type = list(string)
}
