
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name                     = google_compute_network.vpc_network.name
  ip_cidr_range            = "10.2.0.0/16"
  region                   = "europe-west4"
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_iap" {
  name    = "${var.network_name}-allow-iap"
  network = google_compute_network.vpc_network.name


  allow {
    protocol = "tcp"
    ports    = ["22", "8000"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["cromwell"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc_network.name


  allow {
    protocol = "all"
  }
  source_ranges = [google_compute_subnetwork.vpc_subnet.ip_cidr_range]

}

resource "google_compute_router" "cromwell-nat-router" {
  name    = "cromwell-nat-router"
  project = var.project_id
  region  = var.default_region
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "cromwell-nat-gateway" {
  name                               = "nat"
  project                            = var.project_id
  region                             = var.default_region
  router                             = google_compute_router.cromwell-nat-router.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

module "private-service-access" {
  source        = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version       = "8.0.0"
  project_id    = var.project_id
  vpc_network   = google_compute_network.vpc_network.name
  address       = "172.16.50.0"
  prefix_length = 24
  depends_on    = [google_project_service.private_service, google_compute_network.vpc_network]

}
