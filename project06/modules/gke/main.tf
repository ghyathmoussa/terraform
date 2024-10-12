data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.27"
  project = var.project_id
}


module "codeway-vpc" {
  source = "../vpc"
  region = var.region
  project_id = var.project_id
}

resource "google_container_cluster" "primary" {
  name = "${var.project_id}-gke"
  location = "${var.region}"
  project = var.project_id

  remove_default_node_pool = true
  initial_node_count = 2
  network = var.vpc_name
  subnetwork = var.subnetwork
  deletion_protection = false
}

# Manage Node Pool
resource "google_container_node_pool" "codeway-node-pool" {
  name = google_container_cluster.primary.name
  location = var.region
  cluster = google_container_cluster.primary.name
  project = var.project_id

  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
        env = var.project_id
    }

    machine_type = "n1-standart-1"
    tags = ["gke-node", "${var.project_id}-gke"]

    metadata = {
        disable-legacy-endpoints = "true"
    }
  }
}
