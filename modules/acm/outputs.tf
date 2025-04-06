output "aws_acm_records" {
  value       = [for record in cloudflare_record.validation_records : record.hostname]
  description = "DNS 인증에 사용된 record 목록"
}

output "aws_acm_certificate_arn" {
  value       = aws_acm_certificate.domain_certificate.arn
  description = "발급된 acm arn"
}
