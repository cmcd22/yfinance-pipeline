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

variable "layer" {
  description = "Data lake layer (e.g. bronze, silver, gold)."
  type        = string

  validation {
    condition     = contains(["bronze", "silver", "gold"], var.layer)
    error_message = "Layer must be one of: bronze, silver, gold."
  }
}