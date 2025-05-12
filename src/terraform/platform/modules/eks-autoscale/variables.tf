# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_cidr_block" {
  type        = string
  description = "Valor do bloco CDIR da VPC - 10.0.0.0/16"
}

variable "aws_cluster_name" {
  type        = string
  description = "Nome do cluster"
}

variable "aws_cluster_version" {
  type        = string
  description = "Versão do cluster"
}

variable "aws_private_subnets" {
  type        = list(string)
  description = "Lista de subnets privadas"
}

variable "aws_public_subnets" {
  type        = list(string)
  description = "Lista de subnets públicas"
}

variable "aws_lista_az" {
  type = list(string)
  description = "Lista de azs a serem usadas"
}