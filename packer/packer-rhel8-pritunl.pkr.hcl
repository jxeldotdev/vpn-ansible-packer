data "amazon-ami" "rhel8-base" {
  filters = {
    virtualization_type = "hvm"
    name                = "packer_rhel8.3_base_*"
    root-device-type    = "ebs"
  }
  owners      = ["self"]
  most_recent = true
  region      = "ap-southeast-2"
}

variable "ssh_username" {
  type = string
}

variable "security_group_id" {
  type = string
}

source "amazon-ebs" "rhel8" {
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = var.ssh_username
  source_ami    = data.amazon-ami.rhel8-base.id
  security_group_ids = [var.security_group_id]
  ami_name      = "packer-rhel8.3-pritunl-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.rhel8-base"]

  provisioner "ansible" {
    playbook_file = "../ansible/pritunl.yml"
  }
}