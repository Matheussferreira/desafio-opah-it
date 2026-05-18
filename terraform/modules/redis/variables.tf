variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região da instância Redis"
  type        = string
}

variable "instance_name" {
  description = "Nome da instância Memorystore Redis"
  type        = string
}

variable "memory_size_gb" {
  description = "Tamanho de memória em GB"
  type        = number
  default     = 2
}

variable "network_self_link" {
  description = "Self link da VPC autorizada"
  type        = string
}

variable "labels" {
  description = "Labels do recurso"
  type        = map(string)
  default     = {}
}
