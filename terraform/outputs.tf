output "network_name" {
  description = "Nome da VPC criada"
  value       = module.network.network_name
}

output "gke_cluster_name" {
  description = "Nome do cluster GKE Autopilot"
  value       = module.gke.cluster_name
}

output "pubsub_topic" {
  description = "Tópico Pub/Sub principal"
  value       = module.pubsub.topic_name
}

output "cloud_run_service_url" {
  description = "URL do serviço Cloud Run Consolidado"
  value       = module.cloud-run.service_url
}
