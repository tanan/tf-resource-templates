module "default_pub" {
  source = "./modules/alb"

  name = "${var.stage}-default-pub-alb"
  subnets = [
    module.default_subnet_pub_a.subnet_id,
    module.default_subnet_pub_c.subnet_id,
    module.default_subnet_pub_d.subnet_id
  ]
  security_groups            = [aws_security_group.alb_https.id, aws_security_group.alb_http.id]
  internal                   = false
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "default_pub" {
  name        = "${var.stage}-default-pub"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.default_vpc.vpc_id
  target_type = "ip"

  health_check {
    interval            = 15
    path                = "/v1/"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 6
    matcher             = 200
  }
}

resource "aws_alb_listener" "https_api" {
  load_balancer_arn = module.default_pub.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = aws_acm_certificate.api_default_domain.arn

  default_action {
    target_group_arn = aws_alb_target_group.default_pub.arn
    type             = "forward"
  }
}
