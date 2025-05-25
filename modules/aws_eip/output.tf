output "eip_id" {
  value = aws_eip.nat_eip.id
}

output "eip_public_ip" {
  value = aws_eip.nat_eip.public_ip
}