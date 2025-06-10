# GKE VPC &amp; Terraform Backend on GCS

Terraform code in this repository deploys a Google Kubernetes Engine (GKE) Autopilot
cluster alongside the required VPC networking. Terraform state is stored in a
Google Cloud Storage (GCS) bucket so that multiple users can work with the same
state file.

## Prerequisites

- A GCP project with billing enabled
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

Enable the necessary APIs and authenticate:

```bash
gcloud services enable compute.googleapis.com container.googleapis.com
gcloud auth application-default login
```

## Repository Layout

- `main.tf` – Root module wiring the networking and GKE modules and configuring the GCS backend
- `backend/` – Stand‑alone configuration to create the remote state bucket
- `modules/` – Reusable modules
  - `vpc/` – Creates a custom VPC, public/private subnets and Cloud NAT
  - `gke/` – Provisions the Autopilot cluster and IAM roles
- `variables.tf` &amp; `outputs.tf` – Root module inputs and outputs

## Usage

1. **(Optional)** Create the backend bucket if you do not already have one:

   ```bash
   cd backend
   terraform init
   terraform apply
   cd ..
   ```

   Adjust the bucket name in `main.tf` if you used a different name.

2. Initialise and apply the root module:

   ```bash
   terraform init
   terraform apply
   ```

   Pass custom values via `terraform.tfvars` or the `-var` flag.

Terraform provisions the VPC, subnets, Cloud NAT and a new GKE Autopilot
cluster. The state file is written to the bucket configured in `main.tf`.

## Input Variables

Important variables defined in [variables.tf](variables.tf):

| Name | Description | Default |
|------|-------------|---------|
| `project_id` | GCP project ID | n/a |
| `region` | Deployment region | `us-central1` |
| `cluster_name` | Name of the GKE cluster | `my-gke-cluster` |
| `private_subnet_cidrs` | CIDRs for private subnets | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` |
| `public_subnet_cidrs` | CIDRs for public subnets | `["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]` |
| `node_groups` | Node pool settings | see file |

## Outputs

After a successful apply you will see:

- `vpc_id` – ID of the created VPC
- `private_subnet_ids` – IDs of the private subnets
- `public_subnet_ids` – IDs of the public subnets

## Cleanup

Remove all resources with:

```bash
terraform destroy
```

---

This project is provided as-is under the MIT license.

