terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "chris-yfinance-pipeline-tf-state-381492137321-ap-southeast-2-an"
    key          = "terraform/state/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-6"
  profile = "chris-yfinance-pipeline"
}