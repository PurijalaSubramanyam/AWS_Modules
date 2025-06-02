# output "subnet_ids" {
#   value = aws_subnet.my_aws_subnet[*].id
# }
output "subnet_ids" {
  value = aws_subnet.my_aws_subnet[*].id
}
