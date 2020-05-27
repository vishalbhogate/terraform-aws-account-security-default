resource aws_iam_role "ci_deploy" {
  count              = var.create_ci_role ? 1 : 0
  name               = "ci-deploy"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.ci_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF


  max_session_duration = var.role_max_session_duration
}

resource aws_iam_role_policy "ci_deploy" {
  count  = var.create_ci_role ? 1 : 0
  role   = aws_iam_role.ci_deploy[0].id
  name   = "ci-deploy"
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
