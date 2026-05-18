variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região do cluster"
  type        = string
}

variable "network" {
  description = "Nome da rede VPC"
  type        = string
}

variable "subnetwork" {
  description = "Nome da sub-rede"
  type        = string
}

variable "labels" {
  description = "Labels do cluster"
  type        = map(string)
  default     = {}
}
