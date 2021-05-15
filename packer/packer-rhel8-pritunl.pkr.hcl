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

variable "ssh_port" {
  type = string
}


source "amazon-ebs" "rhel8" {
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = var.ssh_username
  ssh_port      = var.ssh_port
  source_ami    = data.amazon-ami.rhel8-base.id
  ami_name      = "packer-rhel8.3-pritunl-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.rhel8-base"]

  provisioner "ansible" {
    playbook_file = "../ansible/pritunl.yml"
  }
}