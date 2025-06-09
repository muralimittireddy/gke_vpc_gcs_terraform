resource "google_service_account" "gke_nodes" {
  account_id   = "${var.cluster_name}-nodes"
  display_name = "GKE Node Service Account"
}

resource "google_project_iam_member" "gke_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/compute.viewer",
    "roles/storage.objectViewer"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region

  network    = var.vpc_id
  subnetwork = var.subnet_id
  enable_autopilot = true
  initial_node_count       = 1

  ip_allocation_policy {}
}

# resource "google_container_node_pool" "default_pool" {
#   for_each = var.node_groups

#   name     = each.key
#   cluster  = google_container_cluster.gke.name
#   location = var.region

#   node_config {
#     machine_type    = "e2-medium"
#     disk_size_gb    = 20            # 👈 reduce from default (usually 100)
#     disk_type       = "pd-standard" # or use "pd-balanced" or "pd-ssd" if needed
#     service_account = google_service_account.gke_nodes.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }

#   initial_node_count = each.value.scaling_config.desired_size

#   autoscaling {
#     min_node_count = 1
#     max_node_count = 1
#   }

#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }
# }
