# conjunto de variaveis do modulo de minikube - pode entrar em conflito com o modulo aws
variable "minikube_driver" {
  type        = string
  description = "Driver usado para executar o minikube"
  default = "docker"
}

variable "minikube_cluster_name" {
  type        = string
  description = "Nome do cluster a ser usado"
  default = "k8s-minikube"
}

variable "minikube_addons" {
  type = list(string)
  description = "Adicionais de configuração do cluster"
  default = [
    "default-storageclass",
    "storage-provisioner",
    "ingress",
    "metrics-server"
  ]
}

variable "minikube_cpus" {
  type        = number
  description = "Numero de CPUs usadas"
  default = 6
}

variable "minikube_memory" {
  type        = string
  description = "Quantidade de memória"
  default = "30g"
}

variable "minikube_nodes" {
  type        = number
  description = "Quantidade de nos"
  default = 1
}



# - conjunto de variaveis do modulo de eks - pode entrar em conflito com o modulo minikube
# variable "aws_cluster_name" {
#   type        = string
#   description = "Nome do cluster a ser usado"
#   default = "k8s-aws"
# }

# variable "aws_cidr_block" {
#   type        = string
#   description = "Valor do bloco CDIR da VPC - 10.0.0.0/16"
#   default = "10.0.0.0/16"
# }

# variable "aws_access_key" {
#   type        = string
#   description = "Valor da chave de acesso usada"
#   default = ""
# }

# variable "aws_secret_key" {
#   type        = string
#   description = "Valor da secret usada para o acesso"
#   default = ""
# }

# variable "aws_cluster_version" {
#   type        = string
#   description = "Versão do cluster"
#   default = "1.30"
# }

# variable "aws_private_subnets" {
#   type        = list(string)
#   description = "Lista de subnets privadas"
#   default = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "aws_public_subnets" {
#   type        = list(string)
#   description = "Lista de subnets públicas"
#   default = ["10.0.4.0/24", "10.0.5.0/24"]
# }

# variable "aws_lista_az" {
#   type = list(string)
#   description = "Lista de azs a serem usadas"
#   default = ["us-east-1a", "us-east-1b"]
# }