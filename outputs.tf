output "yaong_content_access_key" {
  value       = module.cdn_user.s3_uploader_access_key
  description = "yaong-content의 s3 access key"
  sensitive   = true
}

output "yaong_content_secret_key" {
  value       = module.cdn_user.s3_uploader_secret_key
  description = "yaong-content의 s3 secret key"
  sensitive   = true
}
