# backend/main.tf
terraform {
  backend "gcs" {
    bucket = "codeway-state-bucket"
    prefix = "terraform/state"
  }
}
