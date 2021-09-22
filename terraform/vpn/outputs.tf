output "instance_id" {
  value = aws_instance.vpn.id
}

output "private_ip" {
  value = aws_instance.vpn.private_ip
}

output "public_ip" {
  value = aws_instance.vpn.public_ip
}

output "security_group_id" {
  value       = aws_security_group.vpn.id
}
