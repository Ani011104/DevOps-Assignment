locals {
  common_tags = {
    Name        = "${var.Environment}-${var.Project}"
    Environment = var.Environment
    Project     = var.Project
  }
}
