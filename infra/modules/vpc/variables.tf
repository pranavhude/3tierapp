#variable "vpc_cidr" {}
#variable "public_subnets" {}
#variable "private_subnets" {}


variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}
