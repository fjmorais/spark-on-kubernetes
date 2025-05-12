terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.13.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}