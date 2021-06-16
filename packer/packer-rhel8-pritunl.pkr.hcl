data "amazon-ami" "rhel8-base" {
  filters = {
    virtualization-type = "hvm"
    name                = "packer-rhel8.4-base-*"
    root-device-type    = "ebs"
  }
  owners      = ["self"]
  most_recent = true
  region      = "ap-southeast-2"
}

variable "ssh_username" {
  type = string
}

variable "vault_pw_file_path" {
  type = string
}


variable "vault_path" {
  type = string
}


source "amazon-ebs" "rhel8" {
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = var.ssh_username
  source_ami    = data.amazon-ami.rhel8-base.id
  ami_name      = "packer-rhel8.4-pritunl-{{timestamp}}"
  ssh_agent_auth = true
  encrypt_boot  = true
}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "./ansible/pritunl.yml"
    user          = var.ssh_username
    extra_arguments = [ "--vault-password-file=${var.vault_pw_file_path}", "-e @${var.vault_path}" ]
    ansible_env_vars = ["ANSIBLE_SSH_TRANSFER_METHOD=scp"]
  }
}