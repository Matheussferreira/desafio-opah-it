variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região do Cloud Run"
  type        = string
}

variable "service_name" {
  description = "Nome do serviço Cloud Run"
  type        = string
}

variable "topic_name" {
  description = "Tópico Pub/Sub usado pelo serviço"
  type        = string
}

variable "subscription_name" {
  description = "Nome da assinatura Pub/Sub que o serviço consome"
  type        = string
}

variable "concurrency" {
  description = "Número de requisições por instância antes de escalar"
  type        = number
  default     = 10
}

variable "min_instances" {
  description = "Número mínimo de instâncias do Cloud Run"
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Número máximo de instâncias do Cloud Run"
  type        = number
  default     = 20
}

variable "labels" {
  description = "Labels para o serviço"
  type        = map(string)
  default     = {}
}
