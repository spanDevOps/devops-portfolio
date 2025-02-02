terraform {
  backend "s3" {
    bucket         = "spandevops-terraform-state-2024"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
