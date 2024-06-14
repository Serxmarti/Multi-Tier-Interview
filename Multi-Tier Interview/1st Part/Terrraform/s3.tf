resource "aws_s3_bucket" "app_data_bucket" {
  bucket = "my-secure-bucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.rds.arn
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.logging_bucket.id
    target_prefix = "access-logs/"
  }
}

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "my-logging-bucket"
}
