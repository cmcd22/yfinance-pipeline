data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = var.source_code_path
  output_path = "${path.root}/builds/lambda.zip"
}

data "archive_file" "layer_zip" {
  type        = "zip"
  source_dir = var.layer_path
  output_path = "${path.root}/builds/layer.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
    role        = aws_iam_role.lambda_role.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_s3_bronze_policy" {
  name = "${var.project_name}-${var.environment}-lambda-s3-bronze-policy"

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
        Sid    = "ReadWriteBronzeObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${var.bronze_bucket_arn}/*"
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "lambda_s3_bronze_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_bronze_policy.arn
}

resource "aws_lambda_layer_version" "dependencies" {
  s3_bucket            = var.lambda_assets_bucket
  layer_name          = "${var.project_name}-${var.environment}-dependencies"
  compatible_runtimes = [var.runtime]

  s3_key = aws_s3_object.layer_zip.key
}

resource "aws_lambda_function" "bronze_ingestion" {
  function_name = "${var.project_name}-${var.environment}-bronze-ingestion"

  role    = aws_iam_role.lambda_role.arn
  handler = "handler.lambda_handler"
  runtime = var.runtime

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  layers = [
    aws_lambda_layer_version.dependencies.arn
  ]

  timeout     = var.timeout
  memory_size = var.memory

  environment {
    variables = var.environment_variables
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "layer_zip" {
  bucket = var.lambda_assets_bucket
  key    = "lambda-layers/dependencies.zip"
  source = data.archive_file.layer_zip.output_path
  etag   = data.archive_file.layer_zip.output_base64sha256
}
