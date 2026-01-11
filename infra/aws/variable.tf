variable "region" {
  type    = list(string)
  default = ["ap-south-1", "us-east-1"]
}

variable "Environment" {
  type    = string
  default = "dev"
}

variable "Project" {
  type    = string
  default = "pgagi"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

#monitoring variables
variable "alert_email" {
  type        = string
  description = "Email to receive CloudWatch alerts"
}
