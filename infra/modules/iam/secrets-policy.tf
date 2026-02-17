resource "aws_iam_policy" "backend_secrets_policy" {
  name = "backend-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_secrets_attach" {
  role       = aws_iam_role.backend_irsa.name
  policy_arn = aws_iam_policy.backend_secrets_policy.arn
}
