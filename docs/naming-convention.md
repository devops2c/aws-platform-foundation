🌐 Using Local Configuration

All sensitive and environment-specific variables are stored locally in:
global/config.tfvars
This file is never committed to GitHub.

It contains:
Project name (project_name)
Environment (environment)
Owner (owner)
AWS region (region)
Sensitive tokens (token, password)

##To deploy any stack or module, pass the file to Terraform:
terraform init
terraform plan -var-file="../global/config.tfvars"
terraform apply -var-file="../global/config.tfvars"