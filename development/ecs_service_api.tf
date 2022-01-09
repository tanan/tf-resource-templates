resource "aws_ecs_service" "default" {
  name                              = "default-api"
  cluster                           = aws_ecs_cluster.cluster.id
  task_definition                   = aws_ecs_task_definition.default.family
  launch_type                       = "FARGATE"
  desired_count                     = 1
  health_check_grace_period_seconds = "7200"

  load_balancer {
    target_group_arn = aws_alb_target_group.default_pub.arn
    container_name   = "default-api"
    container_port   = 80
  }

  network_configuration {
    subnets          = [module.default_subnet_prv_a.subnet_id, module.default_subnet_prv_c.subnet_id, module.default_subnet_prv_d.subnet_id]
    security_groups  = [aws_security_group.fargate.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "default" {
  family                   = "default-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  task_role_arn            = module.ecs_iam_role.ecs_task_arn
  execution_role_arn       = module.ecs_iam_role.ecs_task_execution_arn

  container_definitions = <<-JSON
  [
    {
      "name": "default-api",
      "image": "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${aws_ecr_repository.default.name}:latest",
      "cpu": 512,
      "memory": 1024,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.fargate_default.name}",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "default-api"
        }
      },
      "environment": [
        {
          "name": "PORT",
          "value": "80"
        }
      ],
      "secrets": [
        {
            "name": "PASSWORD",
            "valueFrom": "default_password"
        }
      ]
    }
  ]
JSON

}
