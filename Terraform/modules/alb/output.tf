output "app_target_group_arn" {
  value = aws_lb_target_group.app_target_group.arn
}

output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "app_lb_zone_id" {
  value = aws_lb.app_lb.zone_id
}
