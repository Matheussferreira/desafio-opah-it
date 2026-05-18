output "host" {
  description = "Endereço IP interno do Redis"
  value       = google_redis_instance.cache.host
}

output "port" {
  description = "Porta do Redis"
  value       = google_redis_instance.cache.port
}
