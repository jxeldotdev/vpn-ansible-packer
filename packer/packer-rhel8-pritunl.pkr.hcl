data "amazon-ami" "rhel8-base" {
  filters = {
    virtualization-type = "hvm"
    name                = "packer-rhel8.3-base-*"
    root-device-type    = "ebs"
  }
  owners      = ["self"]
  most_recent = true
  region      = "ap-southeast-2"
}

variable "ssh_username" {
  type = string
}


source "amazon-ebs" "rhel8" {
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = var.ssh_username
  source_ami    = data.amazon-ami.rhel8-base.id
  ami_name      = "packer-rhel8.3-pritunl-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "./ansible/pritunl.yml"
    user          = "jfreeman"
  }
}