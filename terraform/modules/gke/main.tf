resource "google_container_cluster" "autopilot" {
  name     = "cluster-${var.project_id}"
  location = var.region
  autopilot {
    enabled = true
  }
  network    = var.network
  subnetwork = var.subnetwork
  ip_allocation_policy {
    use_ip_aliases = true
  }
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  labels = var.labels
}
