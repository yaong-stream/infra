output "s3_uploader_access_key" {
  value       = aws_iam_access_key.s3_uploader.id
  description = "생성된 aws iam access key"
  sensitive   = true
}

output "s3_uploader_secret_key" {
  value       = aws_iam_access_key.s3_uploader.secret
  description = "생성된 aws iam secret key"
  sensitive   = true
}
