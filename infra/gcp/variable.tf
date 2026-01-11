#variable.tf
variable "project_id" {
  type        = string
  description = "pg-agi project"
  default     = "pg-agi"
}

variable "region" {
  type        = string
  description = "allowed region for this project"
  default     = "asia-south1"
}

variable "artifact_registry_repo" {
  type        = string
  description = "Artifact Registry repo name"
  default     = "pgagi-docker"
}

variable "frontend_image" {
  type        = string
  description = "Frontend image name (without tag)"
  default     = "pgagi-frontend"
}

variable "backend_image" {
  type        = string
  description = "Backend image name (without tag)"
  default     = "pgagi-backend"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag (usually Git SHA)"
}

