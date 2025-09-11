variable "domain_name" {
  description = "The domain name (e.g., example.com)"
  type        = string
}

variable "project_name" {
  description = "The name of the project (used for naming resources)"
  type        = string
}


variable "alb_dns_name" {
  description = "ALB DNS name"
  type        = string
}

variable "app_lb_zone_id" {
  type        = string
  description = "ALB hosted zone ID"
}
