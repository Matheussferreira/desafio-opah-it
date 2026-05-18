resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  labels                  = var.labels
}

resource "google_compute_subnetwork" "main" {
  name          = "subnet-${var.network_name}"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id
  private_ip_google_access = true
  labels        = var.labels
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router-${var.network_name}"
  network = google_compute_network.main.id
  region  = var.region
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "nat-${var.network_name}"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  min_ports_per_vm                   = 64
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "default_allow_https" {
  name    = "allow-https-${var.network_name}"
  network = google_compute_network.main.name
  direction = "INGRESS"
  allows {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-https"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal-${var.network_name}"
  network = google_compute_network.main.name
  direction = "INGRESS"
  allows {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  source_ranges = ["10.10.0.0/16"]
}
