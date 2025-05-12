# - modulo do cluster minikube
module "minikube_k8s" {
 source = "./modules/minikube"
 minikube_driver = var.minikube_driver
 minikube_cluster_name = var.minikube_cluster_name
 minikube_addons = var.minikube_addons
 minikube_cpus = var.minikube_cpus
 minikube_memory = var.minikube_memory
 minikube_nodes = var.minikube_nodes
}


# - modulo do cluster EKS
# source = "./modules/eks"
# source = "./modules/eks-autoscale"
# source = "./modules/eks-multi-nodegroup"
# source = "./modules/eks-multi-nodegroup-autoscale"
#  module "eks_cluster" {
#     source = "./modules/eks"
#     aws_cidr_block = var.aws_cidr_block
#     aws_cluster_name = var.aws_cluster_name
#     aws_cluster_version = var.aws_cluster_version
#     aws_private_subnets = var.aws_private_subnets
#     aws_public_subnets = var.aws_public_subnets
#     aws_lista_az = var.aws_lista_az
#  }