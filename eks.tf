module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "test-cluster"
  cluster_version = "1.23"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t3.medium"

      key_name = "NVirginiaKey"  # Replace this with your EC2 keypair for SSH access
    }
  }

  tags = {
    "Environment" = "test"
  }
}
