resource "aws_iam_policy" "secrets_manager_access" {
  name        = "backend-secrets-manager-access"
  description = "Allow backend to read Secrets Manager secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]
        Resource = var.secret_arn
      }
    ]
  })
}
