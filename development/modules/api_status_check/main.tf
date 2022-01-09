resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/${var.filename}"
  function_name = var.name
  role          = var.role
  handler       = var.handler

  source_code_hash = filebase64sha256("${path.module}/${var.filename}")

  runtime = "nodejs12.x"

  environment {
    variables = {
      slack_channel = var.slack_channel
    }
  }

}

data "template_file" "log_stream_policy" {
  template = "${file("${path.module}/log_stream_role_policy.json")}"

  vars = {
    region     = var.region
    account_id = var.account_id
    log_group  = var.name
  }
}

resource "aws_iam_policy" "log_stream_policy" {
  name        = "${var.name}-log-stream-role-policy"
  description = "${var.name}-log-stream-role-policy"

  policy = data.template_file.log_stream_policy.rendered
}

resource "aws_iam_role_policy_attachment" "log_stream_policy_attachment" {
  policy_arn = aws_iam_policy.log_stream_policy.arn
  role       = var.role_id
}

data "template_file" "parameter_store_policy" {
  template = "${file("${path.module}/parameter_store_role_policy.json")}"

  vars = {
    region     = var.region
    account_id = var.account_id
    log_group  = var.name
  }
}

resource "aws_iam_policy" "parameter_store_policy" {
  name        = "${var.name}-parameter-store-role-policy"
  description = "${var.name}-parameter-store-role-policy"

  policy = data.template_file.parameter_store_policy.rendered
}

resource "aws_iam_role_policy_attachment" "parameter_store_policy_attachment" {
  policy_arn = aws_iam_policy.parameter_store_policy.arn
  role       = var.role_id
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = var.name
  description = "ScheduleTask"

  schedule_expression = "cron(* * * * ? *)"
}

resource "aws_cloudwatch_event_target" "event_target" {
  target_id = var.name
  arn       = aws_lambda_function.lambda.arn
  rule      = aws_cloudwatch_event_rule.event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}
