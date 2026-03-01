terraform {
  backend "s3" {
    bucket  = "terraform-state-mohamed-2025"
    key     = "stacks/static-site/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}