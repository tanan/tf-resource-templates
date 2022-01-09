resource "aws_eip" "nat" {
  count    = var.has_eip ? 1 : 0
  vpc      = true
  instance = aws_instance.instance.id

  tags = {
    Name = var.name
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = var.ssh_pub_key
}

resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  key_name               = var.key_name

  tags = {
    Name = var.name
  }
}

output public_ip {
  value = length(aws_eip.nat) > 0 ? aws_eip.nat[0].public_ip : null
}
