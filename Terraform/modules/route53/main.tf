resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "${var.project_name}-hosted-zone"
  }
}

resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.main.zone_id 
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.app_lb_zone_id
    evaluate_target_health = true
  }

}
