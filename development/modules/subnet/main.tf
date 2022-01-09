resource "aws_subnet" "subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "association" {
  count          = var.has_route_table ? 1 : 0
  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.route_table_id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}