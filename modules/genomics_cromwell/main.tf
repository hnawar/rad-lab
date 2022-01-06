terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.5.0"
    }
  }
}

provider "google" {
  //Comment or remove this line if running from Cloud Shell
  project = var.project_id
  region  = var.default_region
  zone    = var.default_zone
}

//Enabling required APIs
# Enable services in newly created GCP Proje  "servicenetworking.googleapis.com",    #Private Service Networking


resource "google_project_service" "resource_manager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "service_usage" {
  project            = var.project_id
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "private_service" {
  project            = var.project_id
  service            = "servicenetworking.googleapis.com" #Private Service Networking
  disable_on_destroy = false
}
resource "google_project_service" "sql_components" {
  project            = var.project_id
  service            = "sql-component.googleapis.com" # Cloud SQL
  disable_on_destroy = false
}
resource "google_project_service" "sql_admin" {
  project            = var.project_id
  service            = "sqladmin.googleapis.com" #CloudSQL Admin API
  disable_on_destroy = false
}
resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com" #Cloud IAM
  disable_on_destroy = false
}

resource "google_project_service" "life_sciences" {
  project            = var.project_id
  service            = "lifesciences.googleapis.com" #Life Sciences API
  disable_on_destroy = false
}


//Create Cromwell service account and assign required roles
resource "google_service_account" "cromwell_service_account" {
  project      = var.project_id
  account_id   = "cromwell-sa"
  display_name = "Cromwell Service account"
}

resource "google_project_iam_member" "service_account_roles" {
  count      = length(var.cromwell_sa_roles)
  project    = var.project_id
  role       = var.cromwell_sa_roles[count.index]
  member     = "serviceAccount:${google_service_account.cromwell_service_account.email}"
  depends_on = [google_service_account.cromwell_service_account, google_project_service.iam]
}

