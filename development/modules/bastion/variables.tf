variable "name" {}
variable "ami" {}
variable "subnet_id" {}
variable "key_name" {}
variable "ssh_pub_key" {}
variable "instance_type" {}
variable "has_eip" {}
variable security_group_ids {
  type = list
}
