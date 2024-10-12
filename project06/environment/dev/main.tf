// Read API key from a file
locals {
  api_key   = trimspace(file("./myapikey.txt"))
  api_version = "1" // Assuming the version is stored in a file trimspace(file("./version.txt"))
}

resource "google_secret_manager_secret" "my_api_key" {
  secret_id = "my-api-key"
  project = var.project_id
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}

module "vpc" {
  source = "../../module/vpc"
  region = var.region
  project_id = var.project_id
}

module "cdn" {
  source = "../../modules/cdn"
  region = var.region
  project_id = var.project_id
}

module "gke" {
  source = "../../modules/gke"
  project_id = var.project_id
  region = var.region
  vpc_name = module.vpc.vpc_name
  subnetwork = module.vpc.subnetwork
}


data "google_secret_manager_secret_version" "my_api_key_version" {
  secret  = google_secret_manager_secret.my_api_key.secret_id
  version = local.api_version 
  project = var.project_id
}

resource "google_compute_instance" "default" {
  name         = "example-instance"
  project      = var.project_id
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "codeway"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    api_key = local.api_key  // Use API key from file
  }
  
  metadata_startup_script = "echo hi > /test.txt"
}
