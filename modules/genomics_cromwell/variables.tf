//Common Variables

variable "network_name" {
  type = string

}
variable "project_id" {
  type = string
}
variable "default_region" {
  type = string
}
variable "default_zone" {
  type = string
}


variable "cromwell_sa_roles" {
  description = "List of roles granted to the cromwell service account."
  type        = list(any)
  default = [
    "roles/lifesciences.workflowsRunner",
    "roles/serviceusage.serviceUsageConsumer",
    "roles/storage.objectAdmin",
    "roles/cloudsql.client"
  ]
}

//Cromwell server specific variables
variable "cromwell_server_instance_name" {
  type = string
}
variable "cromwell_server_instance_type" {
  type = string
}

variable "cromwell_port" {
  type = string
}

variable "cromwell_db_name" {
  description = "The name of the SQL Database instance"
  default     = "cromwelldb"
}

variable "cromwell_version" {
  type    = string
  default = "72"

}

variable "cromwell_db_tier" {
  type = string

}

variable "cromwell_db_pass" {
  type = string
}

variable "cromwell_zones" {
  type = string
}

variable "cromwell_PAPI_location" {
  type = string
}

variable "cromwell_PAPI_endpoint" {
  type = string
}