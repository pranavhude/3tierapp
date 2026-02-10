variable "db_host" {
  type        = string
  description = "RDS endpoint"
}

variable "db_port" {
  type        = string
  default     = "3306"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_user" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}
