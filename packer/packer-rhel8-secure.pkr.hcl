variable "vault_pw_file_path" {
  type = string
}

variable "vault_path" {
  type = string
}

source "amazon-ebs" "rhel8" {
  source_ami    = "ami-01ae9b7a0d2d87a64"
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "packer-rhel8.4-base-{{timestamp}}"
  encrypt_boot  = true
}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "./ansible/base.yml"
    extra_arguments = [ "--vault-password-file=${var.vault_pw_file_path}", "-e @${var.vault_path}" ]
    ansible_env_vars = ["ANSIBLE_SSH_TRANSFER_METHOD=scp"]
  }
}