resource "google_redis_instance" "cache" {
  name           = var.instance_name
  tier           = "STANDARD_HA"
  memory_size_gb = var.memory_size_gb
  region         = var.region
  project        = var.project_id

  authorized_network = var.network_self_link
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version = "REDIS_7_0"
  display_name  = "Cache Redis - ${var.instance_name}"
  labels        = var.labels
}
