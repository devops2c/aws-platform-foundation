output "oidc_provider_arn" {
  description = "ARN de l'OIDC Provider GitHub"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "ARN du rôle IAM pour GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}