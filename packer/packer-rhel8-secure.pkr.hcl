variable "vault_pw_file_path" {
  type = string
}

variable "vault_path" {
  type = string
}

source "amazon-ebs" "rhel8" {
  source_ami    = "ami-0a443decce6d88dc2"
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "packer-rhel8.4-base-{{timestamp}}"
  encrypt_boot  = true

  run_tags = {
    Creator = "Packer"
  }
  run_volume_tags = {
    Creator = "Packer"
  }
  snapshot_tags = {
    Creator    = "Packer"
    App        = "BaseImage"
    Repository = "jxeldotdev/vpn-ansible-packer"
  }
  
  tags = {
    Creator    = "Packer"
    App        = "BaseImage"
    Repository = "jxeldotdev/vpn-ansible-packer"
  }
}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "./ansible/base.yml"
    extra_arguments = [ "--vault-password-file=${var.vault_pw_file_path}", "-e @${var.vault_path}" ]
    ansible_env_vars = ["ANSIBLE_SSH_TRANSFER_METHOD=scp"]
  }
}