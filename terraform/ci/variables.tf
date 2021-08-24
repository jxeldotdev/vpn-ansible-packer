variable "service_group_name" {
  type        = string
  default     = "svc_packer_ci"
  description = "Name of AWS IAM group that grants permissions to assume packer builder iam role"
}

variable "service_user_name" {
  type        = string
  default     = "svc_packer_ci"
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
