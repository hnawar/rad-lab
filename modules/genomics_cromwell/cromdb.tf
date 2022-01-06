
module "cromwell-mysql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "8.0.0"


  name       = var.cromwell_db_name
  project_id = var.project_id

  deletion_protection = false

  database_version = "MYSQL_8_0"
  region           = var.default_region
  zone             = var.default_zone
  tier             = var.cromwell_db_tier

  additional_databases = [{ name = "cromwell", collation = "", charset = "" }]


  additional_users = [
    {
      name     = "cromwell"
      password = var.cromwell_db_pass
    }
  ]

  ip_configuration =  {
      ipv4_enabled    = false,
      private_network = google_compute_network.vpc_network.self_link,
      authorized_networks = [],
      require_ssl = false
    }

  // Optional: used to enforce ordering in the creation of resources.
  module_depends_on = [module.private-service-access.peering_completed]
}