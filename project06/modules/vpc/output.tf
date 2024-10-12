output "vpc_name" {
  value = google_compute_network.codeway-vpc.name
}

output "subnetwork" {
  value = google_compute_subnetwork.codeway-subnet.name
}