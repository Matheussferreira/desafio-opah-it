output "topic_name" {
  value = google_pubsub_topic.main.name
}

output "subscription_name" {
  value = google_pubsub_subscription.consolidado.name
}

output "dead_letter_topic_name" {
  value = google_pubsub_topic.dead_letter.name
}
