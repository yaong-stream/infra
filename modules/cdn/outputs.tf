output "s3_arn" {
  value       = aws_s3_bucket.storage_bucket.arn
  description = "생성된 s3 arn"
}
