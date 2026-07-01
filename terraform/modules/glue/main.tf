resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-${var.environment}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "glue_basic_execution" {
    role        = aws_iam_role.glue_role.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_policy" "glue_s3_policy" {
  name = "${var.project_name}-${var.environment}-glue-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBronzeBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.bronze_bucket_arn
      },
      {
        Sid    = "ReadBronzeObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${var.bronze_bucket_arn}/*"
      },
      {
        Sid    = "ListSilverBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.silver_bucket_arn
      },
      {
        Sid    = "ReadWriteSilverObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${var.silver_bucket_arn}/*"
      },
      {
        Sid    = "ListGoldBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.gold_bucket_arn
      },
      {
        Sid    = "WriteGoldObjects"
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${var.gold_bucket_arn}/*"
      },
      {
        Sid    = "ListAssetBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.glue_assets_bucket}"
      },
      {
        Sid    = "ReadAssetObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::${var.glue_assets_bucket}/*"
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "glue_s3_attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_s3_policy.arn
}

resource "aws_s3_object" "silver_script" {
  bucket = var.glue_assets_bucket
  key    = "glue-scripts/silver_transform.py"
  source = var.silver_script_path
  etag   = filemd5(var.silver_script_path)
}

resource "aws_s3_object" "gold_script" {
  bucket = var.glue_assets_bucket
  key    = "glue-scripts/gold_aggregate.py"
  source = var.gold_script_path
  etag   = filemd5(var.gold_script_path)
}

resource "aws_s3_object" "config_script" {
  bucket = var.glue_assets_bucket
  key    = "glue-scripts/config.py"
  source = "${var.shared_code_path}/config.py"
  etag   = filemd5("${var.shared_code_path}/config.py")
}

resource "aws_glue_job" "silver_job" {
    name = "${var.project_name}-${var.environment}-silver-transform"
    role_arn = aws_iam_role.glue_role.arn
    glue_version = "4.0"
    number_of_workers = 2
    worker_type = "G.1X"
    command {
        name            = "glueetl"
        script_location = "s3://${var.glue_assets_bucket}/glue-scripts/silver_transform.py"
        python_version  = "3"
    }
    default_arguments = {
        "--BRONZE_BUCKET"  = var.bronze_bucket_name
        "--SILVER_BUCKET"  = var.silver_bucket_name
        "--extra-py-files" = "s3://${var.glue_assets_bucket}/glue-scripts/config.py"
    }
}

resource "aws_glue_job" "gold_job" {
    name = "${var.project_name}-${var.environment}-gold-transform"
    role_arn = aws_iam_role.glue_role.arn
    glue_version = "4.0"
    number_of_workers = 2
    worker_type = "G.1X"
    command {
        name            = "glueetl"
        script_location = "s3://${var.glue_assets_bucket}/glue-scripts/gold_aggregate.py"
        python_version  = "3"
    }
    default_arguments = {
        "--SILVER_BUCKET"  = var.silver_bucket_name
        "--GOLD_BUCKET"  = var.gold_bucket_name
    }
}