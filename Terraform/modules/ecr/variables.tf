variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {
    Project = "winterEcomm"
    Owner   = "DevOps-Team"
    Env     = "prod"
  }
}

locals {
  common_tags = {
    Project = var.project_name
    Owner   = "DevOps-Team"
  }
}
