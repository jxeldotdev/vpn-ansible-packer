output "instance_id" {
    value = module.vpn_instance.id
}

output "private_ip" {
    value = module.vpn_instance.private_ip
}

output "public_ip" {
    value = module.vpn_instance.public_ip
}
