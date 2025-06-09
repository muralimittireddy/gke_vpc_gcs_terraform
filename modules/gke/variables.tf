variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC network name"
}

variable "subnet_id" {
  type        = string
  description = "Subnetwork name"
}

variable "node_groups" {
  type = map(object({
    instance_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  description = "Node pool configuration"
}