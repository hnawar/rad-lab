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
    network    = module.vpc_cromwell.0.network_name
    subnetwork = module.vpc_cromwell.0.subnets[0].subnet_name

  }
  tags = ["cromwell-iap"]

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


