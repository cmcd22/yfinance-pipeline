variable "environment" {
  description = "Deployment environment (e.g. dev, test, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, prod."
  }
}

variable "silver_script_path" {
  description = "The file path to the silver script source."
  type        = string
}

variable "gold_script_path" {
  description = "The file path to the gold script source."
  type        = string
}

variable "bronze_bucket_arn" {
  description = "The required permissions to query the Bronze S3 bucket."
  type        = string
}

variable "silver_bucket_arn" {
  description = "The required permissions to query the Silver S3 bucket."
  type        = string
}

variable "gold_bucket_arn" {
  description = "The required permissions to query the Gold S3 bucket."
  type        = string
}

variable "bronze_bucket_name" {
  description = "The name of the Bronze S3 bucket."
  type        = string
}

variable "silver_bucket_name" {
  description = "The name of the Silver S3 bucket."
  type        = string
}

variable "gold_bucket_name" {
  description = "The name of the Gold S3 bucket."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "glue_assets_bucket" {
  description = "Bucket where Glue assets are stored."
  type        = string
}

variable "shared_code_path" {
  description = "Path to the shared source code directory."
  type        = string
}