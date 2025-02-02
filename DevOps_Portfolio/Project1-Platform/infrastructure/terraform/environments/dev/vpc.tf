# VPC Configuration
resource "aws_vpc" "main" {
  # CIDR block for the VPC
  cidr_block = var.vpc_cidr

  # Enable DNS hostnames in the VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.project_tags, {
    Name = "${var.environment}-main-vpc"
  })
}
