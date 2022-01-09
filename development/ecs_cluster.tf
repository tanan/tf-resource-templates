resource "aws_ecs_cluster" "cluster" {
  name               = "${var.stage}-default"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }
  default_capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE_SPOT"
    weight            = 0
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "ecs_iam_role" {
  source = "./modules/ecs_iam_role"

  stage  = var.stage
  region = "ap-northeast-1"
}
