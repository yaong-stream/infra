variable "domain_name" {
  type        = string
  description = "인증서를 발급받을 도메인 주소"
  nullable    = false
}

variable "zone_id" {
  type        = string
  description = "cloudflare에서 제공하는 dns zone id"
  nullable    = false
}
