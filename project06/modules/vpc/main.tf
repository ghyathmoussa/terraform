# VPC Module
resource "google_compute_network" "codeway-vpc" {
  name = "codeway-vpc"
  auto_create_subnetworks = false
  project = var.project_id
}

# Subnet
resource "google_compute_subnetwork" "codeway-subnet" {
  name = "codeway-subnet"
  region = var.region
  network = google_compute_network.codeway-vpc.name
  ip_cidr_range = "10.10.0.0/24"
  project = var.project_id
}