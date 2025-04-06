data "aws_iam_policy_document" "access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = var.target_resources
  }
}

resource "aws_iam_policy" "s3_uploader" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.access_policy.json
}

resource "aws_iam_user" "s3_uploader" {
  name = var.uploader
}

resource "aws_iam_user_policy_attachment" "s3_uploader" {
  user       = aws_iam_user.s3_uploader.name
  policy_arn = aws_iam_policy.s3_uploader.arn
}

resource "aws_iam_access_key" "s3_uploader" {
  user = aws_iam_user.s3_uploader.name
}
