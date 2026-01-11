terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region[0]
  alias  = "Primary"
}

provider "aws" {
  region = var.region[1]
  alias  = "Secondary"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "Monitoring"
}
