resource "minikube_cluster" "cluster_k8s" {
  driver       = var.minikube_driver
  cluster_name = var.minikube_cluster_name
  addons = var.minikube_addons
  cpus = var.minikube_cpus
  memory = var.minikube_memory
  nodes = var.minikube_nodes
}