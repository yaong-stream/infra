variable "cloudflare_api_token" {
  type        = string
  description = "cloudflare에서 제공하는 api token"
  nullable    = false
}

variable "cloudflare_zone_id" {
  type        = string
  description = "cloudflare에서 제공하는 dns zone id"
  nullable    = false
}
