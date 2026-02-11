output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  value = replace(
    aws_iam_openid_connect_provider.oidc.url,
    "https://",
    ""
  )
}
