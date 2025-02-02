# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"  # North Virginia region
}

# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Using version 5.x
    }
  }
  required_version = ">= 1.9.0"  # Minimum Terraform version
}
