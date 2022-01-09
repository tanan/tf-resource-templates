module "bastion01" {
  source             = "./modules/bastion"
  name               = "bastion01"
  ami                = "<ami_id>"
  has_eip            = true
  subnet_id          = module.default_subnet_pub_a.subnet_id
  key_name           = "admin"
  ssh_pub_key        = var.ssh_pub_key
  instance_type      = "t2.micro"
  security_group_ids = [aws_security_group.bastion.id]
}