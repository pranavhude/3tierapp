variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}
