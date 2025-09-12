variable "project_name" {
  type    = string
  default = "winterEcomm"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name registered with Route 53"
  type        = string
}

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
}

variable "dns_zone" {
  description = "The Route53 DNS zone"
  type        = string
}
