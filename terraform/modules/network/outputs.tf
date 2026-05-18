output "network_name" {
  value = google_compute_network.main.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.main.name
}

output "network_self_link" {
  value = google_compute_network.main.self_link
}
