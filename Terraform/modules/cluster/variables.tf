variable "project_name" {
  type        = string
  description = "Project name"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for ECS service"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for ECS service"
}

variable "target_group_arn" {
  type        = string
  description = "Target group ARN for load balancer"
}


locals {
  common_tags = {
    Project = var.project_name
    Owner   = "DevOps-Team"
    Env     = "prod"
  }
}
