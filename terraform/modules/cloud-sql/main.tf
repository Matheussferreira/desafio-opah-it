resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region

  settings {
    tier = "db-custom-2-7680"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled = true
      point_in_time_recovery_enabled = true
      retention_unit = "COUNT"
      retained_backups = 7
    }
    ip_configuration {
      ipv4_enabled = false
      private_network = var.network_self_link
    }
    database_flags {
      name  = "cloudsql.maintenance_window"
      value = "sunday:00:00"
    }
  }
  labels = var.labels
}

resource "google_sql_database" "app" {
  name     = "fluxocaixa"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "default" {
  name     = "app_user"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}
