variable "region" {}
variable "project" {}
variable "vpc_cidr" {}
variable "azs" {
  type = list(string)
}

variable "public_subnets" {}
variable "private_subnets" {}

