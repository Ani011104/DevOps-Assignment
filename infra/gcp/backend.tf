#backend.tf
terraform {
  backend "gcs" {
    bucket = "pg-agi-tf-state"
    prefix = "gcp"
  }
}
