module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "iam" {
  source = "./modules/iam"
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
}

module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  cluster_name    = var.cluster_name 

  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  cluster_role    = module.iam.cluster_role_arn
  node_role       = module.iam.node_role_arn
}


