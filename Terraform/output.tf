output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_sg_id" {
  value = module.vpc.public_sg_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}