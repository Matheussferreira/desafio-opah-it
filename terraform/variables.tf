variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região primária"
  type        = string
  default     = "southamerica-east1"
}

variable "network_name" {
  description = "Nome da VPC principal"
  type        = string
  default     = "vpc-desafio-opahit"
}

variable "subnet_cidr" {
  description = "CIDR da sub-rede principal"
  type        = string
  default     = "10.10.0.0/20"
}

variable "db_instance_name" {
  description = "Nome da instância Cloud SQL"
  type        = string
  default     = "postgres-desafio"
}

variable "cloud_run_service_name" {
  description = "Nome do serviço Cloud Run"
  type        = string
  default     = "consolidado-service"
}

variable "project_labels" {
  description = "Labels padrão para recursos"
  type = map(string)
  default = {
    env         = "prd"
    owner       = "arquitetura"
    cost-center = "OPAHIT"
    app         = "fluxo-caixa"
  }
}
