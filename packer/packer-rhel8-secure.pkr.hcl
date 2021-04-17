source "amazon-ebs" "rhel8" {
  source_ami    = "ami-0a963156d94c557a8"
  region        = "ap-southeast-2"
  instance_type = "t2.micro"
  ssh_user      = "ec2-user"
  ami_name      = "packer-rhel8.3-base-{{timestamp}}"

}

build {
  sources = ["source.amazon-ebs.rhel8"]

  provisioner "ansible" {
    playbook_file = "../ansible/base.yml"
  }
}