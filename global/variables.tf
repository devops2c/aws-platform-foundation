variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "token" {
  description = "Sensitive token for deployment"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Sensitive password"
  type        = string
  sensitive   = true
}
