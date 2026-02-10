module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  cluster_role    = module.iam.cluster_role_arn
  node_role       = module.iam.node_role_arn
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  db_name         = var.db_name
  db_user         = var.db_user
  db_password     = var.db_password
}
