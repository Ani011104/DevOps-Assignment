#cloudrun.tf
resource "google_cloud_run_service" "frontend" {
  name     = "frontend"
  location = var.region

  template {
    metadata {
      labels = local.common_labels
    }

    spec {
      service_account_name = google_service_account.frontend_sa.email

      containers {
        image = local.frontend_image_uri

        ports {
          container_port = 3000
        }

        env {
          name  = "NEXT_PUBLIC_BACKEND_URL"
          value = google_cloud_run_service.backend.status[0].url
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Public access
resource "google_cloud_run_service_iam_member" "frontend_public" {
  service  = google_cloud_run_service.frontend.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}


#Creating same cloud run service for backend
resource "google_cloud_run_service" "backend" {
  name     = "backend"
  location = var.region

  template {
    metadata {
      labels = local.common_labels
    }

    spec {
      service_account_name = google_service_account.backend_sa.email

      containers {
        image = local.backend_image_uri

        ports {
          container_port = 8000
        }

        env {
          name  = "ENV"
          value = "dev"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Public access (can be restricted later)
resource "google_cloud_run_service_iam_member" "backend_public" {
  service  = google_cloud_run_service.backend.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
