resource "aws_acm_certificate" "winter-acm" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "winter-acm-val" {
  certificate_arn         = aws_acm_certificate.winter-acm.arn
  validation_record_fqdns = [aws_route53_record.dns-validation-main.fqdn]
}


resource "aws_route53_record" "dns-validation-main" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.winter-acm.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.winter-acm.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.winter-acm.domain_validation_options)[0].resource_record_type
  zone_id         = var.zone_id 
  ttl             = var.dns_record_ttl
}