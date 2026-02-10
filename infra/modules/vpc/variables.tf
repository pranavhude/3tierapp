variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDR blocks"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDR blocks"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}
