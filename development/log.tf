resource "aws_cloudwatch_log_group" "fargate_nginx" {
  name = "${var.stage}-fargate-nginx"

  tags = {
    Environment = var.stage
    Application = "nginx"
  }
}

resource "aws_cloudwatch_log_group" "fargate_default_api" {
  name = "${var.stage}-fargate-default-api"

  tags = {
    Environment = var.stage
    Application = "default-api"
  }
}