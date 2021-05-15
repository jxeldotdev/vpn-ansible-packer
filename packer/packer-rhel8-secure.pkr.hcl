variable "sg_id" {
  type = string
}

source "amazon-ebs" "rhel8" {
  source_ami    = "ami-0a963156d94c557a8"
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "packer-rhel8.3-base-{{timestamp}}"
  security_group_id = var.sg_id

  security_group_filter {
    filters = {
      "tag:Class": "CustomPackerGroup"
    }
  }
}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "./ansible/base.yml"
    extra_arguments = [ "--vault-password-file=./ansible/vault-password" ]
  }
}