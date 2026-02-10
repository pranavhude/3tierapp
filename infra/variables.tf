variable "region" {}
variable "project" {}
variable "vpc_cidr" {}
variable "azs" {
  type = list(string)
}

variable "public_subnets" {}
variable "private_subnets" {}

variable "db_name" {}
variable "db_user" {}
variable "db_password" {
  sensitive = true
}
