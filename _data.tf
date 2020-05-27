data "aws_iam_policy_document" "assume_role_extra" {
  count = length(var.extra_roles)

  statement {
    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.idp_account_id}:root",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "labs_developer" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
  statement {
    sid       = "DenySelfIAM"
    effect    = "Deny"
    actions   = ["iam:*"]
    resources = ["arn:aws:iam::*:role/${var.org_name}-labs-*"]
  }
  statement {
    sid    = "LimitRDSDBInstanceType"
    effect = "Deny"
    actions = [
      "rds:CreateDBInstance",
      "rds:CreateDBCluster"
    ]
    resources = ["arn:aws:rds:*:*:db:*"]
    condition {
      test     = "ForAnyValue:StringNotLike"
      variable = "rds:DatabaseClass"
      values   = ["*.micro"]
    }
  } /* 
  # statement {
  #   sid    = "DenyifAuthorNotProvided"
  #   effect = "Deny"
  #   actions = [
  #     "ec2:RunInstances",
  #     "ec2:CreateVolume"
  #   ]
  #   resources = [
  #     "arn:aws:ec2:*:*:volume/*",
  #     "arn:aws:ec2:*:*:instance/*"
  #   ]
  #   condition {
  #     test     = "StringNotEquals"
  #     variable = "aws:RequestTag/Author"
  #     values   = ["&{aws:username}"]
  #   }
  #   condition {
  #     test     = "ForAllValues:StringNotEquals"
  #     variable = "aws:RequestTag/Author"
  #     values   = ["&{aws:username}"]
  #   }
  # }
  statement {
    sid    = "DenyifPurposeNotProvided"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:instance/*"
    ]
    condition {
      test     = "ForAllValues:StringNotEquals"
      variable = "aws:TagKeys"
      values   = ["Purpose"]
    }
  }
  statement {
    sid    = "DenyifNameNotProvided"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:instance/*"
    ]
    condition {
      test     = "ForAllValues:StringNotEquals"
      variable = "aws:TagKeys"
      values   = ["Name"]
    }
  }
  statement {
    sid    = "DenyifEnvironmentNotProvided"
    effect = "Deny"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:instance/*"
    ]
    condition {
      test     = "ForAllValues:StringNotEquals"
      variable = "aws:TagKeys"
      values   = ["Environment"]
    }
  }
  statement {
    sid    = "DenyDeleteTagforMatched"
    effect = "Deny"
    actions = [
      "ec2:DeleteTags"
    ]
    resources = ["*"]
    condition {
      test     = "ForAllValues:StringNotEquals"
      variable = "aws:TagKeys"
      values   = ["Purpose", "Name", "Environment"]
    }
  } */
  statement {
    sid    = "LimitEBSVolumeType"
    effect = "Deny"
    actions = [
      "ec2:AttachVolume",
      "ec2:RunInstances",
      "ec2:CreateVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*"
    ]
    condition {
      test     = "ForAnyValue:StringNotEqualsIgnoreCase"
      variable = "ec2:VolumeType"
      values   = ["gp2"]
    }
  }
  statement {
    sid    = "LimitEBSVolumeSize"
    effect = "Deny"
    actions = [
      "ec2:AttachVolume",
      "ec2:RunInstances",
      "ec2:CreateVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*"
    ]
    condition {
      test     = "ForAnyValue:NumericGreaterThan"
      variable = "ec2:VolumeSize"
      values   = ["30"]
    }
  }
  statement {
    sid    = "LimitInstanceTypes"
    effect = "Deny"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*"
    ]
    condition {
      test     = "StringNotEqualsIgnoreCase"
      variable = "ec2:InstanceType"
      values   = ["t2.micro"]
    }
  }
}