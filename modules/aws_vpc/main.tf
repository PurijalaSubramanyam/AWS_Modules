# Terraform module to create a VPC with an Internet Gateway and a Route Table
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "my_vpc" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "my_vpc" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name        = "${var.vpc_name}-rt"
    Environment = var.environment
  }
}

