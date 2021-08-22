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

variable "svc_packer_role_name" {
  type = object({
    description = string
    name        = string
  })
}

variable "operator_name" {
  type        = string
  default     = "jfreeman"
  description = "Name of Adminstrator's / Operator's IAM user."
}

variable "pgp_key" {
  type        = string
  default     = ""
  description = "description"
}
