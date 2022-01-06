output "Cromell_server_internal_IP" {
  value = google_compute_instance.cromwell_server.network_interface[0].network_ip

}

output "Cromwell_DB_Private_IP" {
  value = module.cromwell-mysql-db.instance_ip_address[0].ip_address
}

output "Cromwell_service_account_email" {
  value = google_service_account.cromwell_service_account.email
}

output "GCS_Bucket_URL" {
  value = google_storage_bucket.cromwell_workflow_bucket.url
}
