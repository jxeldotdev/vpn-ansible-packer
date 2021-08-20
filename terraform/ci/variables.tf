variable "service_group_name" {
  type        = string
  default     = ""
  description = "Name of AWS IAM group that grants permissions to assume packer builder iam role"
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