# 1. Define the S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.project_name}-${var.layer}-${var.environment}"

  tags = {
    Name = "${var.project_name}-${var.layer}-${var.environment}"
    Environment = "${var.environment}"
    Layer = "${var.layer}"
  }
}

# 2. Enable Versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enforce Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}