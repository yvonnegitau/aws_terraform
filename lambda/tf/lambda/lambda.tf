resource "aws_s3_object" "lambda_function" {
  bucket = aws_s3_bucket.code_bucket.id
  key    = "localstack_test/lambda_function.zip"
  source = data.archive_file.lambda_function.output_path
  etag   = filemd5(data.archive_file.lambda_function.output_path)

  lifecycle {
    ignore_changes = all
  }
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "hello_word_function" {
  function_name = "HelloWorldLambda"
  handler       = "hello_world.main_handler"
  runtime       = "python3.7"
  role          = aws_iam_role.lambda_execution_role.arn

  s3_bucket = aws_s3_bucket.code_bucket.bucket
  s3_key    = aws_s3_object.lambda_function.key

  environment {
    variables = {
      test_var = "hello"
    }
  }
}