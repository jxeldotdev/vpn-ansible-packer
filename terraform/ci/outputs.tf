output "svc_role_arn" {
  value       = aws_iam_role.service_role.arn
  sensitive   = false
  description = "ARN of service role"
}

output "svc_user_access_key" {
  value     = module.service_user.iam_access_key_id
  sensitive = true
}

output "svc_user_secret_key" {
  value     = module.service_user.iam_access_key_encrypted_secret
  sensitive = true
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  sensitive   = true
  description = "List of public subnets in VPC"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of private subnets in VPC"
}


