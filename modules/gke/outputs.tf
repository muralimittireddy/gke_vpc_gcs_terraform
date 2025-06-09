output "cluster_endpoint" {
  value       = google_container_cluster.gke.endpoint
  description = "GKE cluster endpoint"
}

output "cluster_name" {
  value       = google_container_cluster.gke.name
  description = "GKE cluster name"
}
