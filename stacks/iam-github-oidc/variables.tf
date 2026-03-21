variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "github_org" {
  description = "GitHub organization ou username"
  type        = string
  default     = "devops2c"  # REMPLACE par ton vrai username GitHub
}

variable "github_repo" {
  description = "Nom du repository GitHub"
  type        = string
  default     = "aws-platform-foundation"   # Le rôle IAM doit savoir **QUEL repo GitHub** peut l'utiliser (sécurité).
}

#Gestion des roles et permissions pour GitHub Actions a assumer ( au lieu de donnner AdminRole)
variable "github_actions_permissions" {
  description = "Permissions pour GitHub Actions"
  type        = list(string)
  default = [
    "s3:*",
    "iam:GetRole",
    "iam:PassRole",
    "sts:GetCallerIdentity"
  ]
}
