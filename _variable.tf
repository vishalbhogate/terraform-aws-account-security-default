variable "account_name" {
  description = "Account name (slug)"
}

variable "org_name" {
  description = "Name for this organization (slug)"
}

variable "create_idp_trusted_roles" {
  default     = true
  description = "Name for this organization (slug)"
}

variable "idp_account_id" {
  description = "Account ID of IDP account (needs to be set when is_idp_account=true)"
  default     = ""
}

variable "idp_external_trust_account_ids" {
  type        = list(string)
  description = "List of account IDs to trust as external IDPs"
  default     = [""]
}

variable "role_max_session_duration" {
  description = "Maximum CLI/API session duration"
  default     = "43200"
}

variable "extra_roles" {
  default     = []
  description = "A list of extra roles to create in this account"
}

variable "extra_roles_policy_arn" {
  default     = {}
  description = "A map of { <role_name> = <policy arn> } to attach policies to extra roles in this account (role must be declared at extra_roles first)"
}

variable "extra_roles_policy" {
  default     = {}
  description = "A map of { <role_name> = <json policy> } to create policies to extra roles in this account (role must be declared at extra_roles first)"
}

variable "create_ci_role" {
  default     = true
  description = "Create IAM role to assume from MGMT account for CI deployments"
}

variable "ci_account_id" {
  description = "Account ID of MGMT account for use with IAM CI role. Required when create_ci_iam_role=true"
  default     = ""
}

variable "create_ci_profile" {
  description = "Create IAM instance profile and user for use with CI workers deployed to the account"
  default     = false
}