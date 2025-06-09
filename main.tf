terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket  = "vikrammm971tfbucket-2"
    prefix  = "terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  region               = var.region
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
}

module "eks" {
  source      = "./modules/gke"
  cluster_name = var.cluster_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id      # Self link
  subnet_id    = module.vpc.private_subnet_ids[0] # Self link of one private subnet
  node_groups  = var.node_groups
  project_id   = var.project_id
}