data "aws_ami" "vpn_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
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
  key_name   = var.key_pair_name
  public_key = var.pub_key
}


resource "aws_instance" "vpn" {
  ami = data.aws_ami.vpn_ami.id

  # REQUIRED FOR VPN TO WORK PROPERLY!
  source_dest_check           = false

  user_data                   = var.user_data
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.vpn.id]
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.vpn_key_pair.id
  monitoring                  = true
  associate_public_ip_address = true

  root_block_device {
    encrypted   = true
    volume_size = "20"
  }


  tags = {
    Terraform = "True"
    App       = "Pritunl"
  }
}