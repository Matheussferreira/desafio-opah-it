output "instance_connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}

output "db_username" {
  value = google_sql_user.default.name
}

output "db_password" {
  description = "Senha do usuário gerado automaticamente"
  value       = random_password.db_password.result
  sensitive   = true
}
