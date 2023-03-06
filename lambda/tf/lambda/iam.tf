data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "helloworld-api-execution-role"


  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [{
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow"
      }]
    }
  )
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.code_bucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "code_bucket_gh_actions_policy_document" {
  statement {
    sid    = "GHUserPermissionS3"
    effect = "Allow"

    actions = [
      "s3:getObject",
      "s3:putObject",
    ]

    resources = [
      "${data.aws_s3_bucket.code_bucket.arn}",
      "${data.aws_s3_bucket.code_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "GHUserUpdateFunctionRole"
    effect = "Allow"

    actions = [
      "lambda:UpdateFunctionCode"
    ]

    resources = [
      "${aws_lambda_function.lambda_function.arn}" ]
  }
}

resource "aws_iam_user_policy" "code_bucket_gh_actions_policy" {
  name   = "${aws_iam_user.gh_actions.name}-code-bucket-policy"
  user   = aws_iam_user.gh_actions.id
  policy = data.aws_iam_policy_document.code_bucket_gh_actions_policy_document.json


}