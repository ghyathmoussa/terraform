# Create Storge Bucket 

resource "google_storage_bucket" "codeway-cdn-bucket" {
  name = "codeway-cdn-bucket"
  location = "US"
  project = var.project_id
}


resource "google_compute_backend_bucket" "codeway-backend-bucket" {
  name = "codeway-backend-bucket"
  bucket_name = "codeway-cdn-bucket"
  enable_cdn = true
  project = var.project_id
}

resource "google_compute_url_map" "cdn_url_map" {
  name            = "cdn-url-map"
  description     = "CDN URL map to cdn_backend_bucket"
  default_service = google_compute_backend_bucket.codeway-backend-bucket.id
  project = var.project_id
}


resource "google_compute_target_http_proxy" "codeway-cdn-http-proxy" {
  name = "codeway-cdn-http-proxy"
  url_map = google_compute_url_map.cdn_url_map.self_link
  project = var.project_id
}

resource "google_compute_global_address" "codeway-cdn-public-address" {
  name         = "codeway-cdn-public-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
  project      = var.project_id
}

