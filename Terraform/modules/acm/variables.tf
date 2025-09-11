variable "domain_name" {
  type        = string
  description = "The name of the DNS"
}

variable "dns_record_ttl" {
  type        = number
  description = "The TTL for the DNS record"
}

variable "dns_zone" {
  type    = string
  
}

variable "zone_id" {
  description = "The Route 53 zone ID used for DNS validation"
  type        = string
}
