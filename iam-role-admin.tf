resource "aws_iam_role" "admin" {
  count = var.create_idp_trusted_roles ? 1 : 0

  name = "${var.org_name}-${var.account_name}-admin"
  #Principal should be valid and existing.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS":
          ${jsonencode(
  concat(
    ["arn:aws:iam::${var.idp_account_id}:root"],
    formatlist(
      "arn:aws:iam::%s:role/${var.org_name}-admin",
      var.idp_external_trust_account_ids,
    ),
    formatlist(
      "arn:aws:iam::%s:role/client-admin",
      var.idp_external_trust_account_ids,
    ),
  ),
)}
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF


max_session_duration = var.role_max_session_duration
}

resource aws_iam_role_policy "admin" {
  count = var.create_idp_trusted_roles ? 1 : 0
  name  = "idp-admin-access"
  role  = aws_iam_role.admin[0].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

