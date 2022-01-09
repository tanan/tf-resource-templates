variable "name" {}
variable "subnets" {
  type = list
}
variable "security_groups" {
  type = list
}
variable "internal" {}
variable "enable_deletion_protection" {}