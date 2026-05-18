variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região de recursos"
  type        = string
}

variable "network_name" {
  description = "Nome da VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR da sub-rede"
  type        = string
}

variable "labels" {
  description = "Labels padrão"
  type        = map(string)
  default     = {}
}
