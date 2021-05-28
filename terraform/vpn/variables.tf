variable "ami_filter" {
    type    = string
    default = "packer-rhel8.4-pritunl*"
}

variable "instance_name" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t3a.small"
}


variable "key_pair_name" {
    type = string
}

variable "pub_key" {
    type = string
}

variable "sg_name" {
    type = string
}

variable "sg_desc" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "webui_port" {
    type = number
}

variable "vpn_client_cidr" {
    type = string
}

variable "vpn_port" {
    type = string
}

variable "home_ip" {
    type = string
}

variable "subnet_id" {
    type = string
}