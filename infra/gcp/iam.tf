#iam.tf
resource "google_service_account" "frontend_sa" {
  account_id   = "frontend-cloudrun-sa"
  display_name = "Frontend Cloud Run SA"
}

resource "google_service_account" "backend_sa" {
  account_id   = "backend-cloudrun-sa"
  display_name = "Backend Cloud Run SA"
}

# Allow Cloud Run to pull images
resource "google_project_iam_member" "frontend_ar_pull" {
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.frontend_sa.email}"
  project = var.project_id
}

resource "google_project_iam_member" "backend_ar_pull" {
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
  project = var.project_id
}

# Backend can read secrets
resource "google_project_iam_member" "backend_secret_access" {
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
  project = var.project_id
}
