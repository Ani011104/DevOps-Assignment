
locals {
  common_labels = {
    name        = "pg-agi"
    environment = "dev"
    project     = "pg-agi"
  }

  frontend_image_uri = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repo}/${var.frontend_image}:${var.image_tag}"
  backend_image_uri  = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repo}/${var.backend_image}:${var.image_tag}"
}
