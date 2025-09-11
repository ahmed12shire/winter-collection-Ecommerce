variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "certificate_arn" {
  type        = string
  description = "The certificate ARN"
}

locals {
  common_tags = {
    Project = var.project_name
    Owner   = "DevOps-Team"
    Env     = "prod"
  }
}