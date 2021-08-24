######################################
## Role used by CI / GitHub Actions ##
######################################

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  // Allow users in root acount to assume this role.
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.root_aws_account_id}:root"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = ["86400"]
    }
  }
}

data "aws_iam_policy_document" "service_role_permissions_secretsmanager" {
  statement {
    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:PutSecretValue",
      "secretsmanager:RestoreSecret",
      "secretsmanager:UpdateSecret"
    ]
    resources = [aws_secretsmanager_secret.ansible_vault_pass.arn]
  }
}

// Taken from https://blog.stefan-koch.name/202/05/16/restricted-packer-aws-permissions
data "aws_iam_policy_document" "service_role_permissions_packer" {
  statement {
    sid = "RatherSafeActions"
    actions = [
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DescribeImages",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:GetPasswordData"
    ]
    resources = ["*"]
  }
  statement {
    sid = "DangerousActions"
    actions = [
      "ec2:AttachVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DetachVolume",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:StopInstances",
      "ec2:TerminateInstances"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Creator"
      values   = ["Packer"]
    }
  }
}

// IAM policy that grants permissions to access SecretsManager
module "service_role_policy_secretsmanager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 3.0"

  name        = var.svc_secretsmanager_policy_info.name
  path        = "/"
  description = var.svc_secretsmanager_policy_info.description
  policy      = data.aws_iam_policy_document.service_role_permissions_secretsmanager.json
}

// Policy to grant permissions required for building AMIs
module "service_role_policy_packer" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 3.0"

  name        = var.svc_packer_policy_info.name
  path        = "/"
  description = var.svc_packer_policy_info.description
  policy      = data.aws_iam_policy_document.service_role_permissions_packer.json

}

resource "aws_iam_role" "service_role" {
  name               = var.svc_packer_role_name.name
  path               = "/"
  description        = var.svc_packer_role_name.description
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

module "service_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name                          = var.service_user_name
  create_iam_user_login_profile = false
  create_iam_access_key         = true
  pgp_key                       = var.pgp_key
  force_destroy                 = true
}

// Group that allows users to Assume CI Role
module "service_role_group" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"

  name            = var.service_group_name
  assumable_roles = [aws_iam_role.service_role.arn]
  group_users     = [module.service_user.iam_user_name]
  depends_on      = [module.service_user, aws_iam_role.service_role]
}

resource "aws_secretsmanager_secret" "ansible_vault_pass" {
  name = var.vault_pass_secret_name
}