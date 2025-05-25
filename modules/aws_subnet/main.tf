resource "aws_subnet" "my_aws_subnet" {
  count             = var.subnet_count
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name        = "${var.vpc_name}-subnet-${count.index}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "this" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.my_aws_subnet[count.index].id
  route_table_id = var.route_table_id
}

data "aws_availability_zones" "available" {}