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