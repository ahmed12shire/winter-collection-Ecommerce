output "certificate_arn" {
  description = "The certificate ARN"
  value       = aws_acm_certificate.winter-acm.arn
}