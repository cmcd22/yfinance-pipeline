variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, test, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, prod."
  }
}

variable "aws_region" {
  description = "AWS region where resources will be deployed."
  type        = string
  default     = "ap-southeast-6"
}