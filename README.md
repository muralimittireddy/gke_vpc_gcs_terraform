# GKE VPC & Terraform Backend on GCS

This repository contains Terraform configurations to deploy a Google Kubernetes Engine (GKE) Autopilot cluster together with the supporting network infrastructure on Google Cloud Platform (GCP). The Terraform state is stored remotely in a Google Cloud Storage (GCS) bucket.

## Repository Structure

- **main.tf** - Root module that wires the networking and GKE modules together and configures the GCS backend.
- **backend/** - Stand‑alone configuration that provisions the GCS bucket used as the Terraform backend.
- **modules/** - Reusable Terraform modules:
  - `vpc/` provisions a custom VPC, private and public subnets, and Cloud NAT.
  - `gke/` deploys the GKE Autopilot cluster and related IAM resources.
- **variables.tf** and **outputs.tf** - Input variables and outputs for the root module.

## Getting Started

1. Ensure the [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) are installed.
2. Authenticate with GCP:
   ```bash
   gcloud auth application-default login
   ```
3. (Optional) Provision the backend bucket:
   ```bash
   cd backend
   terraform init
   terraform apply
   cd ..
   ```
4. Initialise and apply the root module:
   ```bash
   terraform init
   terraform apply
   ```

Terraform will create the VPC, subnets, Cloud NAT, and a new GKE Autopilot cluster. State is stored in the bucket specified in `main.tf`.

## Input Variables

Key variables defined in [variables.tf](variables.tf):

| Name | Description | Default |
|------|-------------|---------|
| `project_id` | GCP project ID | n/a |
| `region` | GCP region | `us-central1` |
| `cluster_name` | Name of the GKE cluster | `my-gke-cluster` |
| `private_subnet_cidrs` | CIDR ranges for private subnets | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` |
| `public_subnet_cidrs` | CIDR ranges for public subnets | `["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]` |
| `node_groups` | Map describing node pool settings | see file |

Adjust these variables as needed via a `terraform.tfvars` file or the `-var` flag.

## Outputs

After apply, the following values are output:

- `vpc_id` – ID of the created VPC.
- `private_subnet_ids` – IDs of the private subnets.
- `public_subnet_ids` – IDs of the public subnets.

## Cleanup

To remove all resources managed by this configuration, run:

```bash
terraform destroy
```

## License

This project is provided as-is under the MIT license.

