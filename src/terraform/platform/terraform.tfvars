
# - minikube
minikube_driver = "docker"

minikube_cluster_name = "k8s-minikube"

minikube_addons = [
    "default-storageclass",
    "storage-provisioner",
    "ingress",
    "metrics-server"
]

 minikube_cpus = 6

 minikube_memory = "20g"

 minikube_nodes = 1



# - AWS
# aws_cluster_name = "k8s-aws"

# aws_cidr_block = "10.0.0.0/16"

# aws_access_key = ""

# aws_secret_key = ""

# aws_cluster_version ="1.30"

# aws_private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

# aws_public_subnets = ["10.0.4.0/24", "10.0.5.0/24"]

# aws_lista_az = ["us-east-1a", "us-east-1b"]