resource "aws_s3_bucket" "code_bucket" {
    bucket = var.code_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "code" {
  bucket = aws_s3_bucket.code_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}