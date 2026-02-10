variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "three-tier-tf-state-bucket"
}

variable "dynamodb_table" {
  default = "terraform-locks"
}
