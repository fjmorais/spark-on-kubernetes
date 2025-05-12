variable "argocd_name" {
  type        = string
}

variable "argocd_repository" {
  type        = string
}

variable "argocd_chart" {
  type        = string
}

variable "argocd_namespace" {
  type        = string
}

variable "argocd_create_namespace" {
  type        = bool
}

variable "argocd_version" {
  type        = string
}

variable "argocd_verify" {
  type        = bool
}