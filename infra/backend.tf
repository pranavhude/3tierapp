terraform {
  backend "s3" {
    bucket         = "three-tier-tf-state-bucket"
    key            = "prod/eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
