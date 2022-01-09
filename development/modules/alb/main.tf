resource "aws_alb" "alb" {
  name                       = var.name
  security_groups            = var.security_groups
  subnets                    = var.subnets
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket = var.name
  }
}

output "arn" {
  value = aws_alb.alb.arn
}

output "domain_name" {
  value = aws_alb.alb.dns_name
}

output "zone_id" {
  value = aws_alb.alb.zone_id
}