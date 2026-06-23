output "function_name" {
    description = "The name of the Lambda function."
    value = aws_lambda_function.bronze_ingestion.function_name
}

output "function_arn" {
    description = "The ARN of the Lambda function."
    value = aws_lambda_function.bronze_ingestion.arn
}