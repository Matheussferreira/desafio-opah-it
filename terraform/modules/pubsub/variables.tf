variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "topic_name" {
  description = "Nome do tópico Pub/Sub"
  type        = string
}

variable "subscription_name" {
  description = "Nome da assinatura Pub/Sub"
  type        = string
}

variable "dead_letter_topic_name" {
  description = "Nome do tópico DLQ"
  type        = string
}

variable "labels" {
  description = "Labels dos recursos"
  type        = map(string)
  default     = {}
}
