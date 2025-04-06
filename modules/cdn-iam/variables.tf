variable "target_resources" {
  type        = list(string)
  description = "AWS S3 arn 리소스 목록"
  nullable    = false
}

variable "policy_name" {
  type        = string
  description = "생성할 aws iam policy 명"
  nullable    = false
}

variable "uploader" {
  type        = string
  description = "생성할 aws iam 유저 명"
  nullable    = false
}
