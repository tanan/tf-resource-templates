resource "aws_iam_role" "ecs_task" {
  assume_role_policy = file("${path.module}/ecs_assume_role_policy.json")
  name               = "${var.stage}-ecs-task"
}

data "template_file" "execution_assume_role_policy" {
  template = "${file("${path.module}/execution_assume_role_policy.json")}"

  vars = {
    region = "${var.region}"
  }
}

data "template_file" "ssm_role_policy" {
  template = "${file("${path.module}/ssm_role_policy.json")}"
}

resource "aws_iam_policy" "ssm_role_policy" {
  name        = "ssm-role-policy"
  description = "ssm-role-policy"

  policy = data.template_file.ssm_role_policy.rendered
}

resource "aws_iam_role" "ecs_task_execution" {
  assume_role_policy = data.template_file.execution_assume_role_policy.rendered
  name               = "${var.stage}-ecs-task-execution"
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = aws_iam_role.ecs_task.id
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution.id
}

resource "aws_iam_role_policy_attachment" "fetch_ssm" {
  policy_arn = aws_iam_policy.ssm_role_policy.arn
  role       = aws_iam_role.ecs_task_execution.id
}

resource "aws_iam_role_policy_attachment" "ecr_power_user" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.ecs_task.id
}

data "aws_iam_policy_document" "autoscaling_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }
  }
}

output "ecs_task_arn" {
  value = aws_iam_role.ecs_task.arn
}

output "ecs_task_execution_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}