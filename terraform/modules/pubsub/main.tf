resource "google_pubsub_topic" "main" {
  name   = var.topic_name
  labels = var.labels
}

resource "google_pubsub_topic" "dead_letter" {
  name   = var.dead_letter_topic_name
  labels = var.labels
}

resource "google_pubsub_subscription" "consolidado" {
  name  = var.subscription_name
  topic = google_pubsub_topic.main.name

  ack_deadline_seconds = 60
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
  dead_letter_policy {
    dead_letter_topic = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 5
  }
  labels = var.labels
}
