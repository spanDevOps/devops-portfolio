# Environment variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"  # Dev Environment
}

# Project tags
variable "project_tags" {
  description = "Tags for the project"
  type        = map(string)
  default     = {
    Project     = "platform"
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}
