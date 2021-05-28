data "aws_ami" "vpn_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name = "name"
    values = [var.ami_filter]
  }


  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "vpn_key_pair" {
  key_name = var.key_pair_name
  public_key = var.pub_key
}

module "vpn_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = var.instance_name
  instance_count         = 1

  ami                    = data.aws_ami.vpn_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.vpn_key_pair.id
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.vpn.id]
  subnet_id              = var.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
    App         = "Pritunl"
  }
}
