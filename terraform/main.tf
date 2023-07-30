# setup provider
provider "aws" {
  region = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files = ["~/.aws/config"]
}

# get info about available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# prepare experssions for public and private subnet cidrs
locals {
  private_subnets = [for i in range(var.az_count): cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, i)]
  public_subnets = [for i in range(var.az_count): cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, i + var.az_count)]
}

# setup VPC, public/private subnets, IGW, NAT GW, security groups and routes and route tables
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "eks-vpc"
  cidr = var.vpc_cidr
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  create_igw = true
  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets = local.private_subnets
  public_subnets = local.public_subnets

   public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# setup EKS cluster with managed node group
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.15.4"

  cluster_name = var.eks_cluster_name
  cluster_version = var.kubernetes_version

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    instance_types = var.node_instance_types
  }

  eks_managed_node_groups = {
    group1 = {
      name = "eks-node-group-1"
      min_size = var.node_group_min_size
      max_size = var.node_group_max_size
      desired_size = var.node_group_desired_size
    }
  }
}