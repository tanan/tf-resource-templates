resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = module.default_vpc.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [
      "126.208.117.161/32",
      "133.242.55.93/32",
    ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-bastion"
  }
}

resource "aws_security_group" "alb_https" {
  name   = "alb-https"
  vpc_id = module.default_vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-alb"
  }
}

resource "aws_security_group" "alb_http" {
  name   = "alb-http"
  vpc_id = module.default_vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-alb"
  }
}

resource "aws_security_group" "fargate" {
  name   = "argate"
  vpc_id = module.default_vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb_https.id, aws_security_group.alb_http.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-fargate"
  }
}

resource "aws_security_group" "aurora_mysql" {
  name   = "aurora-mysql"
  vpc_id = module.default_vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.fargate.id, aws_security_group.bastion.id]
  }

  tags = {
    Name = "sg-aurora-mysql"
  }
}
