resource "google_service_account" "cloud_run_sa" {
  account_id   = "sa-consolidado"
  display_name = "Service Account do Cloud Run Consolidado"
  project      = var.project_id
}

resource "google_pubsub_subscription_iam_member" "cloud_run_subscriber" {
  project      = var.project_id
  subscription = var.subscription_name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_cloud_run_service" "consolidado" {
  name     = var.service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "run.googleapis.com/min-instances" = tostring(var.min_instances)
        "run.googleapis.com/max-instances" = tostring(var.max_instances)
      }
    }
    spec {
      service_account_name  = google_service_account.cloud_run_sa.email
      container_concurrency = var.concurrency
      containers {
        image = "gcr.io/${var.project_id}/consolidado:latest"
        env {
          name  = "PUBSUB_SUBSCRIPTION"
          value = var.subscription_name
        }
        resources {
          limits = {
            cpu    = "1"
            memory = "2Gi"
          }
        }
      }
    }
  }

  traffics {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
  labels                     = var.labels
}
