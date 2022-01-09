locals {
  vpc_cidr          = "10.1.0.0/16"
  subnet_cidr_pub_a = "10.1.1.0/24"
  subnet_cidr_pub_c = "10.1.2.0/24"
  subnet_cidr_pub_d = "10.1.3.0/24"
  subnet_cidr_prv_a = "10.1.11.0/24"
  subnet_cidr_prv_c = "10.1.12.0/24"
  subnet_cidr_prv_d = "10.1.13.0/24"
  subnet_cidr_db_a  = "10.1.21.0/24"
  subnet_cidr_db_c  = "10.1.22.0/24"
  subnet_cidr_db_d  = "10.1.23.0/24"
}

module "default_vpc" {
  source = "./modules/vpc"

  name     = var.project
  vpc_cidr = local.vpc_cidr
}

module "default_nat_gateway" {
  source = "./modules/nat-gateway"

  name      = "${var.project}-nat-a"
  subnet_id = module.default_subnet_pub_a.subnet_id
}

module "default_route_table_pub" {
  source = "./modules/route"

  is_public  = true
  name       = "${var.project}-pub"
  vpc_id     = module.default_vpc.vpc_id
  gateway_id = module.default_vpc.gateway_id
}

module "default_route_table_prv" {
  source = "./modules/route"

  is_public  = false
  name       = "${var.project}-prv"
  vpc_id     = module.default_vpc.vpc_id
  gateway_id = module.default_nat_gateway.gateway_id
}

module "default_subnet_pub_a" {
  source = "./modules/subnet"

  name              = "${var.project}-pub-a"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_pub_a
  availability_zone = "ap-northeast-1a"
  has_route_table   = true
  route_table_id    = module.default_route_table_pub.pub_route_table_id
}

module "default_subnet_pub_c" {
  source = "./modules/subnet"

  name              = "${var.project}-pub-c"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_pub_c
  availability_zone = "ap-northeast-1c"
  has_route_table   = true
  route_table_id    = module.default_route_table_pub.pub_route_table_id
}

module "default_subnet_pub_d" {
  source = "./modules/subnet"

  name              = "${var.project}-pub-d"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_pub_d
  availability_zone = "ap-northeast-1d"
  has_route_table   = true
  route_table_id    = module.default_route_table_pub.pub_route_table_id
}

module "default_subnet_prv_a" {
  source = "./modules/subnet"

  name              = "${var.project}-prv-a"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_prv_a
  availability_zone = "ap-northeast-1a"
  has_route_table   = true
  route_table_id    = module.default_route_table_prv.prv_route_table_id
}

module "default_subnet_prv_c" {
  source = "./modules/subnet"

  name              = "${var.project}-prv-c"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_prv_c
  availability_zone = "ap-northeast-1c"
  has_route_table   = true
  route_table_id    = module.default_route_table_prv.prv_route_table_id
}

module "default_subnet_prv_d" {
  source = "./modules/subnet"

  name              = "${var.project}-prv-d"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_prv_d
  availability_zone = "ap-northeast-1d"
  has_route_table   = true
  route_table_id    = module.default_route_table_prv.prv_route_table_id
}

module "default_subnet_db_a" {
  source = "./modules/subnet"

  name              = "${var.project}-db-a"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_db_a
  availability_zone = "ap-northeast-1a"
  has_route_table   = false
}

module "default_subnet_db_c" {
  source = "./modules/subnet"

  name              = "${var.project}-db-c"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_db_c
  availability_zone = "ap-northeast-1c"
  has_route_table   = false
}

module "default_subnet_db_d" {
  source = "./modules/subnet"

  name              = "${var.project}-db-d"
  vpc_id            = module.default_vpc.vpc_id
  cidr_block        = local.subnet_cidr_db_d
  availability_zone = "ap-northeast-1d"
  has_route_table   = false
}
