module "network" {
  source      = "./modules/network"
  project_id  = var.project_id
  region      = var.region
  network_name = var.network_name
  subnet_cidr = var.subnet_cidr
  labels      = var.project_labels
}

module "gke" {
  source      = "./modules/gke"
  project_id  = var.project_id
  region      = var.region
  network     = module.network.network_name
  subnetwork  = module.network.subnetwork_name
  labels      = var.project_labels
}

module "pubsub" {
  source        = "./modules/pubsub"
  project_id    = var.project_id
  topic_name    = "topic-transactions"
  subscription_name = "sub-consolidado"
  dead_letter_topic_name = "topic-transactions-dlq"
  labels        = var.project_labels
}

module "cloud-sql" {
  source           = "./modules/cloud-sql"
  project_id       = var.project_id
  region           = var.region
  instance_name    = var.db_instance_name
  database_version = "POSTGRES_15"
  network_self_link = module.network.network_self_link
  labels           = var.project_labels
}

module "redis" {
  source            = "./modules/redis"
  project_id        = var.project_id
  region            = var.region
  instance_name     = "redis-cache"
  memory_size_gb    = 2
  network_self_link = module.network.network_self_link
  labels            = var.project_labels
}

module "cloud-run" {
  source            = "./modules/cloud-run"
  project_id        = var.project_id
  region            = var.region
  service_name      = var.cloud_run_service_name
  topic_name        = module.pubsub.topic_name
  subscription_name = module.pubsub.subscription_name
  labels            = var.project_labels
}
