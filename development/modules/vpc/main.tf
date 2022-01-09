
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "gateway_id" {
  value = aws_internet_gateway.igw.id
}