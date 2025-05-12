# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "cluster-eks"

  cidr =  var.aws_cidr_block 
  azs  = var.aws_lista_az 

  private_subnets = var.aws_private_subnets 
  public_subnets  = var.aws_public_subnets  

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    =  var.aws_cluster_name 
  cluster_version = var.aws_cluster_version  

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_eks/NodegroupAmiType.html
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  # normal lab
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      # https://costcalc.cloudoptimo.com/aws-pricing-calculator/ec2/t2.small
      # t2.small, t2.medium, t2.large, t2.xlarge
      #    1/2  ,     2/4  ,    2/8  ,    4/16
      instance_types = ["t2.medium"]

      capacity_type = "SPOT"

      min_size     = 3
      max_size     = 5
      desired_size = 3
    }
  }
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"
  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}


resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"

  set {
    name  = "args"
    value = "{--kubelet-insecure-tls}"
  }
}