variable "environment" {
  description = "Deployment environment (e.g. dev, test, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, prod."
  }
}

variable "source_code_path" {
  description = "The file path to the code source."
  type        = string
}

variable "runtime" {
  description = "The function runtime."
  type        = string
}

variable "timeout" {
  description = "The length of time before the function times out."
  type        = number
}

variable "memory" {
  description = "The amount of memory used."
  type        = number
}

variable "bronze_bucket_arn" {
  description = "The required permissions to query the S3 bucket."
  type        = string
}

variable "environment_variables" {
    description = "Environmental variables."
    type        = map(string)
}

variable "layer_path" {
    description = "Path to the dependancies layer."
    type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "lambda_assets_bucket" {
  description = "Bucket where layer zip is stored."
  type        = string 
}