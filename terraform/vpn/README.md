# VPN Terraform Module

Deploys an EC2 instance and required security groups for a single-node VPN deployment.

## Inputs
|Name|Description|Type   |Default|Required   |
|---|---|---|---|---|
|ami_filter|Regex used to search for AMI   |String   |packer-rhel8.4-pritunl*   |True   |
|instance_name   |name of ec2 instance   |String   |   |True   |
|instance_type   |AWS EC2 Instance type   |String   |t3a.small   |False   |
|key_pair_name   |Name of EC2 Key pair to create   |String   |   |True   |
|pub_key|(RSA) OpenSSH Public key used to create AWS EC2 SSH Key   |String   |   |True   |
|sg_name|Name of security group to create for VPN   |String   |   |True   |
|sg_desc|Description of security group to create for VPN   |String  |   |True   |
|vpc_id|ID of VPC to deploy instance in   |String   |   |True  |
|webui_port|Port of Pritunl web ui   |Number   |443  |False   |
|vpn_client_cidr|CIDR block for VPN - used in security group rules   |String   |   |True   |
|vpn_port|VPN Port to allow in security group rules   |   |   |   |
|home_ip|IP to allow access to    |   |   |True   |
|subnet_id|ID of subnet to deploy instance in   |String   |   |True   |

## Outputs
|Name|Description   |
|---|---|
|instance_id   |ID of EC2 instance|
|private_ip|Private IP of EC2 instance| 
|public_ip|Public IP of EC2 instance|