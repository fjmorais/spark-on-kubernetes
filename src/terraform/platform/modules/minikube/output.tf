# Expoe os dados de um resource que pode ser usado em outros resouces 
# Isso também é usado para criar dependência entre os módulos
output "cluster_name" {
  description = "Mostra o nome do cluster que foi criado"
  value = minikube_cluster.cluster_k8s.cluster_name
}