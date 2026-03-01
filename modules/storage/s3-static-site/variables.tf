variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable bucket encryption"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Destroy bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "public_access_block" {
  description = "Block all public access"
  type        = bool
  default     = true
}

variable "website_index_document" {
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "Error document for static website"
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
  default     = {}
}

name: Terraform CI/CD

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  terraform-plan:
    name: Terraform Plan
    runs-on: ubuntu-latest
    timeout-minutes: 10

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.0.0

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Terraform Init
        run: terraform init
        working-directory: stacks/static-site

      - name: Terraform Plan
        run: terraform plan -out=tfplan
        working-directory: stacks/static-site

      - name: Upload Plan
        uses: actions/upload-artifact@v3
        with:
          name: tfplan
          path: stacks/static-site/tfplan

  terraform-apply:
    name: Terraform Apply
    runs-on: ubuntu-latest
    timeout-minutes: 15
    needs: terraform-plan
    environment: production

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.0.0

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Download Plan
        uses: actions/download-artifact@v3
        with:
          name: tfplan
          path: stacks/static-site

      - name: Terraform Init
        run: terraform init
        working-directory: stacks/static-site

      - name: Terraform Apply
        run: terraform apply tfplan
        working-directory: stacks/static-site