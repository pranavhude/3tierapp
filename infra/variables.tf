variable "region" {}
variable "project" {}
variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(string)
}
variable "cluster_name" {
  type = string
}
variable "public_subnets" {}
variable "private_subnets" {}

