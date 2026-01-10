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
