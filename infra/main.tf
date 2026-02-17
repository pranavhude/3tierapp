module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  cluster_name = var.cluster_name
}

module "iam" {
  source = "./modules/iam"
  oidc_provider_url = module.eks.oidc_provider_url
}

module "eks" {
  source          = "./modules/eks"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  
  cluster_name    = var.cluster_name
  cluster_role    = module.iam.cluster_role_arn
  node_role       = module.iam.node_role_arn
}


