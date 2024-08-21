data "aws_caller_identity" "current" {}

# sre role
resource "aws_iam_role" "sre_role" {
  name                 = "sre-srv"
  description          = "This role allows sre-srv access to services for deployment"
  max_session_duration = "21600"
  assume_role_policy   = data.aws_iam_policy_document.sre_pol.json
  path                 = "/"
}

data "aws_iam_policy_document" "sre_pol" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_instance_profile" "sre_server_inst_profile" {
  name = "sreProfile"
  role = aws_iam_role.sre_role.name
}

resource "aws_iam_policy" "sre_policy" {
  name        = "sre-server-policy"
  path        = "/"
  description = "Service role for sre"
  policy      = data.aws_iam_policy_document.sre_server_pol_doc.json
}

resource "aws_iam_role_policy_attachment" "sre_server_pol_attach" {
  role       = aws_iam_role.sre_role.name
  policy_arn = aws_iam_policy.sre_policy.arn
}

data "aws_iam_policy_document" "sre_server_pol_doc" {
  statement {
    sid    = "Secrets"
    effect = "Allow"

    actions = [
      "secretsmanager:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "SSMAllow"
    effect = "Allow"

    actions = [
      "ssm:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "IAM"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "CrossAccount"
    effect = "Allow"

    actions = [
      "sts:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "SES"
    effect = "Allow"
    actions = [
      "ses:*"
    ]

    resources = [
      "*"
    ]
  }
}
