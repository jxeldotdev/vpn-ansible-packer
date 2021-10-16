variable "vault_pw_file_path" {
  type = string
}

variable "vault_path" {
  type = string
}

variable "ami_users" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "git_ref" {
  type = string
}

source "amazon-ebs" "rhel8" {
  source_ami    = "ami-050625d0ff8cea3f3"
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "packer-rhel8.4-pritunl-${var.git_ref}-{{timestamp}}"
  ami_users     = var.ami_users

  subnet_filter {
    filters = {
      "tag:Environment": "Build" 
    }
  }

  subnet_id = var.subnet_id

  vpc_filter {
    filters = {
      "tag:Environment": "Build"
    }
  }
  
  run_tags = {
    Creator = "Packer"
  }
  run_volume_tags = {
    Creator = "Packer"
  }
  snapshot_tags = {
    Creator    = "Packer"
    App        = "Pritunl"
    Commit     = var.git_ref
    Repository = "jxeldotdev/vpn-ansible-packer"
  }
  
  tags = {
    Creator    = "Packer"
    App        = "Pritunl"
    Commit     = var.git_ref
    Repository = "jxeldotdev/vpn-ansible-packer"
  }
}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "./ansible/main.yml"
    user          = "ec2-user"
    extra_arguments = [ "--vault-password-file=${var.vault_pw_file_path}", "-e @${var.vault_path}" ]
    ansible_env_vars = ["ANSIBLE_SSH_TRANSFER_METHOD=scp"]
  }
}