provider "google" {
  project = "kubecommerce"
  region  = "us-central1"
}

resource "google_storage_bucket" "terraform_state" {
  name          = "vikrammm971tfbucket-2"
  location      = "US"
  force_destroy = false
  versioning {
    enabled = true
  }
}