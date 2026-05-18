variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região do Cloud SQL"
  type        = string
}

variable "instance_name" {
  description = "Nome da instância Cloud SQL"
  type        = string
}

variable "database_version" {
  description = "Versão do PostgreSQL"
  type        = string
}

variable "network_self_link" {
  description = "Self link da rede VPC para conexão privada"
  type        = string
}

variable "labels" {
  description = "Labels dos recursos"
  type        = map(string)
  default     = {}
}
