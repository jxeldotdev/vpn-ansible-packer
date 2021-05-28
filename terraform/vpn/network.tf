data "aws_subnet" "vpn_subnet" {
    id = var.subnet_id
}

data "aws_vpc" "vpn" {
    id = var.vpc_id
}

resource "aws_security_group" "vpn" {
  name        = var.sg_name
  description = var.sg_desc
  vpc_id      = data.aws_vpc.vpn.id
}

// Allow Web UI traffic to home IP
resource "aws_security_group_rule" "web_ui" {
  type              = "ingress"
  from_port         = var.webui_port
  to_port           = var.webui_port
  protocol          = "tcp"
  cidr_blocks       = [var.home_ip]
  security_group_id = aws_security_group.vpn.id
}


// Required for LetsEncrypt to work properly
resource "aws_security_group_rule" "letsencrypt" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}

// Allow VPN Traffic
resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = var.vpn_port
  to_port           = var.vpn_port
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}

// Allow SSH
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.home_ip, var.vpn_client_cidr]
  security_group_id = aws_security_group.vpn.id
}

// Outbound traffic
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}
