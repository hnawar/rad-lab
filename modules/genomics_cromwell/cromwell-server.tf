
resource "google_compute_instance" "cromwell_server" {
  name                      = var.cromwell_server_instance_name
  machine_type              = var.cromwell_server_instance_type
  zone                      = "europe-west4-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # // Local SSD disk
  # scratch_disk {
  #   interface = "SCSI"
  # }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

  }
  tags = ["cromwell"]

  metadata = {
    startup-script-url = "${google_storage_bucket.cromwell_workflow_bucket.url}/provisioning/bootstrap.sh"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.cromwell_service_account.email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    google_storage_bucket_object.bootstrap,
    google_storage_bucket_object.config,
    google_storage_bucket_object.service
  ]
}


resource "google_storage_bucket" "cromwell_workflow_bucket" {
  name                        = "${var.project_id}-cromwell-wf-exec"
  location                    = var.default_region
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "config" {
  name   = "provisioning/cromwell.conf"
  bucket = google_storage_bucket.cromwell_workflow_bucket.name
  content = templatefile("scripts/cromwell.conf", {
    cromwell_PAPI_location = var.cromwell_PAPI_location,
    cromwell_PAPI_endpoint = var.cromwell_PAPI_endpoint,
    requester_pay_project  = var.project_id,
    cromwell_zones         = var.cromwell_zones,
    cromwell_port          = var.cromwell_port,
    cromwell_db_ip         = module.cromwell-mysql-db.instance_ip_address[0].ip_address,
    cromwell_db_pass       = var.cromwell_db_pass
  })
}

resource "google_storage_bucket_object" "bootstrap" {
  name   = "provisioning/bootstrap.sh"
  bucket = google_storage_bucket.cromwell_workflow_bucket.name
  content = templatefile("scripts/bootstrap.sh", {
    cromwell_version = var.cromwell_version,
    bucket_url       = google_storage_bucket.cromwell_workflow_bucket.url
  })
}
resource "google_storage_bucket_object" "service" {
  name   = "provisioning/cromwell.service"
  source = "scripts/cromwell.service"
  bucket = google_storage_bucket.cromwell_workflow_bucket.name
}