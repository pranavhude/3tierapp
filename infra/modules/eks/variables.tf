variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "cluster_role" {
  type = string
}

variable "node_role" {
  type = string
}
