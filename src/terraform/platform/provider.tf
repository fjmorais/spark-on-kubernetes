terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.13.2"
    }
  }
}

# Modulo usado pelo minikube - pode entrar em conflito com o modulo do aws
provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "minikube"
}

# Modulo usado pelo minikube - pode entrar em conflito com o modulo do aws
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
  }
}


# provider "aws" {
#   region = "us-east-1"
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
# }

# provider "kubernetes" {
#   host                   = module.eks_cluster.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
#     command     = "aws"
#   }
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks_cluster.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
#       command     = "aws"
#     } 
#   }
# }
