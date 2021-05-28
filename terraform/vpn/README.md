# VPN Terraform Module

Deploys an EC2 instance and required security groups for a Pritunl VPN Deployment.

## Inputs
|Name|Description|Type   |Default|Required   |
|---|---|---|---|---|
|ami_filter|   |   |   |   |
|instance_name   |   |   |   |   |
|instance_type   |   |   |   |   |
|key_pair_name   |   |   |   |   |
|pub_key|   |   |   |   |
|sg_name|   |   |   |   |
|sg_desc|   |   |   |   |
|vpc_id|   |   |   |   |
|webui_port|   |   |   |   |
|vpn_client_cidr|   |   |   |   |
|vpn_port|   |   |   |   |
|home_ip|   |   |   |   |
|subnet_id|   |   |   |   |

## Outputs
|Name|Description   |
|---|---|
|instance_id   |ID of EC2 instance|
|private_ip|Private IP of EC2 instance| 
|public_ip|Public IP of EC2 instance|