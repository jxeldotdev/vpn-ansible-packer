source "amazon-ebs" "basic-example" {
  source_ami_filter {
    filters = {
       virtualization-type = "hvm"
        # TODO: CHANGE TO RHEL8
       name = "ubuntu/images/\*ubuntu-xenial-16.04-amd64-server-\*"
       root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
  }
}
