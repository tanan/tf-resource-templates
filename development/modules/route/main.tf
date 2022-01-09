resource "aws_route_table" "public" {
  count  = var.is_public ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "private" {
  count  = var.is_public ? 0 : 1
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.gateway_id
  }

  tags = {
    Name = var.name
  }
}

output "pub_route_table_id" {
  value = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "prv_route_table_id" {
  value = length(aws_route_table.private) > 0 ? aws_route_table.private[0].id : null
}
