resource aws_ssm_parameter "account_id" {
  count = length(var.ssm_account_ids)
  name  = "/account/${var.ssm_account_names[count.index]}/id"
  type  = "String"
  value = var.ssm_account_ids[count.index]
}
