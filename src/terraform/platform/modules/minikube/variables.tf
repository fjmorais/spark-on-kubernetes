variable "minikube_driver" {
  type        = string
  description = "Driver usado para executar o minikube"
}

variable "minikube_cluster_name" {
  type        = string
  description = "Nome do cluster a ser usado"
}

variable "minikube_addons" {
  type = list(string)
  description = "Adicionais de configuração do cluster"
}

variable "minikube_cpus" {
  type        = number
  description = "Numero de CPUs usadas"
}

variable "minikube_memory" {
  type        = string
  description = "Quantidade de memória"
}

variable "minikube_nodes" {
  type        = number
  description = "Quantidade de nós"
}