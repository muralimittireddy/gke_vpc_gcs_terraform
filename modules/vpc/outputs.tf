output "vpc_id" {
  value       = google_compute_network.vpc.id
  description = "VPC network ID"
}

output "private_subnet_ids" {
  value       = google_compute_subnetwork.private[*].id
  description = "Private subnet IDs"
}

output "public_subnet_ids" {
  value       = google_compute_subnetwork.public[*].id
  description = "Public subnet IDs"
}
