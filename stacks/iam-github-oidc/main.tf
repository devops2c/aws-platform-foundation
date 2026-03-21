# Récupère l'Account ID AWS actuel
data "aws_caller_identity" "current" {}

# Crée l'OIDC Provider GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    Name      = "GitHub Actions OIDC Provider"
    ManagedBy = "Terraform"
  }
}

# Crée le rôle IAM pour GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name      = "GitHub Actions Role"
    ManagedBy = "Terraform"
  }
}
/*Attribution de la politique d'accès (ici, on peut choisir des permissions plus spécifiques que AdministratorAccess pour limiter les risques)
Bonne pratique : éviter d'utiliser des permissions trop larges (comme AdministratorAccess) en production, et privilégier des politiques personnalisées avec les permissions minimales nécessaires.
Attache les permissions AdministratorAccess
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
*/
#Atacche Policy custom avec permissions minimales (instead of AdministratorAccess)

resource "aws_iam_role_policy" "github_actions_policy" {
  name = "GitHubActionsPolicy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",                    # Gestion S3 (buckets, objets)
          "iam:GetRole",             # Lecture rôles IAM
          "iam:PassRole",            # Passage de rôle
          "sts:GetCallerIdentity"    # Vérification identité
        ]
        Resource = "*"
      }
    ]
  })
}