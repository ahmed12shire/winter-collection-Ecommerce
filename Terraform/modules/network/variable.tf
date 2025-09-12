
# variables

variable "project_name" {
  default = "winterEcomm"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(string)
  default = {
    "public1" = "10.0.1.0/24"
    "public2" = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  type = map(string)
  default = {
    "private1" = "10.0.3.0/24"
  }
}

variable "allow_cidrs" {
    type = list(string)
    default = ["0.0.0.0/0"]
}

data "aws_availability_zones" "available" {}

variable "az_count" {
  default = 2
}


variable "public_sg_ingress" {
  type = map(object({
    from     = number
    to       = number
    protocol = string
  }))
  default = {
    ssh   = { from = 22, to = 22, protocol = "tcp" }
    http  = { from = 80, to = 80, protocol = "tcp" }
    https = { from = 443, to = 443, protocol = "tcp" }
    ecs   = { from = 80, to = 80, protocol = "tcp" }

  }
}


# LOCALS

locals {
  common_tags = {
    Project = var.project_name
    Owner   = "DevOps-Team"
  }
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

# zipmap
locals {
  public_subnets_with_az = zipmap(keys(var.public_subnets), local.azs)
  private_subnets_with_az = zipmap(
    keys(var.private_subnets),
    [for i in range(length(keys(var.private_subnets))) : local.azs[i % length(local.azs)] ]
  )
}

