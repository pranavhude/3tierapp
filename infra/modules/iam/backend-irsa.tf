resource "aws_iam_role" "backend_irsa" {
  name = "backend-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "oidc.eks.ap-south-1.amazonaws.com/id/${var.oidc_id}:sub" :
            "system:serviceaccount:default:backend-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_secrets_attach" {
  role       = aws_iam_role.backend_irsa.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}
