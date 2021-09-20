variable "service_group_name" {
  type        = string
  default     = "AllowAssumePackerRole"
  description = "Name of AWS IAM group that grants permissions to assume packer builder iam role"
}

variable "service_user_name" {
  type        = string
  default     = "PackerCIServiceUser"
  description = "Name of IAM user used in CI to assume packer iam role"
}

variable "svc_secretsmanager_policy_info" {
  type = object({
    description = string
    name        = string
  })
}

variable "svc_packer_policy_info" {
  type = object({
    description = string
    name        = string
  })
}

variable "svc_packer_role_name" {
  type = object({
    description = string
    name        = string
  })
}

variable "pgp_key" {
  type        = string
  default     = "keybase:joelfreeman"
  description = "PGP Key used for encrypting IAM Access Keys"
}

variable "root_aws_account_id" {
  type        = string
  description = "Root AWS Account ID - This is included in the assume_role_policy document for IAM Role."
}

/* AWS Secrets Manager - Ansible Vault related variables */

variable "vault_pass_secret_name" {
  type        = string
  description = "Name of AWS SecretsManager secret for Ansible Vault Password"
}

variable "vault_pass_secret_value" {
  type        = string
  sensitive   = true
}