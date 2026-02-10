################################
# AWS SECRETS MANAGER SECRET
################################
resource "aws_secretsmanager_secret" "db" {
  name        = "prod/db/credentials"
  description = "Database credentials for backend application"
}

################################
# SECRET VALUE
################################
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    DB_HOST     = var.db_host
    DB_PORT     = var.db_port
    DB_NAME     = var.db_name
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
  })
}
