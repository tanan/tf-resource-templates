data "aws_ssm_parameter" "default_api_db_pwd" {
  name = "default_api_db_pwd"
}

resource "aws_db_subnet_group" "default" {
  name = "default"
  subnet_ids = [
    module.default_subnet_db_a.subnet_id,
    module.default_subnet_db_c.subnet_id,
    module.default_subnet_db_d.subnet_id
  ]
}

resource "aws_rds_cluster" "default" {
  cluster_identifier              = "${var.stage}-default"
  db_subnet_group_name            = aws_db_subnet_group.default.name
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.04.5"
  engine_mode                     = "provisioned"
  master_password                 = data.aws_ssm_parameter.default_api_db_pwd.value
  master_username                 = "defaultadmin"
  vpc_security_group_ids          = [aws_security_group.aurora_mysql.id]
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  # deletion_protection  = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-default-${count.index}"
  engine             = "aurora-mysql"
  engine_version     = "5.7.mysql_aurora.2.04.5"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.t3.small"
  # performance_insights_enabled = true
}