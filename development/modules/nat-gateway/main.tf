resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.name
  }
}

output "gateway_id" {
  value = aws_nat_gateway.nat.id
}