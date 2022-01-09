variable "name" {}
variable "vpc_id" {}
variable "cidr_block" {}
variable "availability_zone" {}
variable "has_route_table" {}
variable "route_table_id" {
  default = ""
}