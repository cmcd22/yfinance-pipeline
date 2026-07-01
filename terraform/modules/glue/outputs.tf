output "silver_job_name" {
    description = "The name of the Silver Glue job."
    value = aws_glue_job.silver_job.name
}

output "silver_job_arn" {
    description = "The ARN of the Silver Glue job."
    value = aws_glue_job.silver_job.arn
}

output "gold_job_name" {
    description = "The name of the Gold Glue job."
    value = aws_glue_job.gold_job.name
}

output "gold_job_arn" {
    description = "The ARN of the Gold Glue job."
    value = aws_glue_job.gold_job.arn
}