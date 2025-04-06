module "global_acm" {
  source      = "./modules/acm"
  domain_name = "narumir.io"
  zone_id     = var.cloudflare_zone_id
  providers = {
    aws        = aws.global
    cloudflare = cloudflare
  }
}

module "cdn" {
  source                  = "./modules/cdn"
  bucket_name             = "yaong-content"
  domain_name             = "narumir.io"
  fqdn_domain_name        = "cdn-yaong.narumir.io"
  zone_id                 = var.cloudflare_zone_id
  aws_acm_certificate_arn = module.global_acm.aws_acm_certificate_arn
}

module "cdn_user" {
  source      = "./modules/cdn-iam"
  policy_name = "yaong_cotents"
  uploader    = "yaong_cotents"
  target_resources = [
    module.cdn.s3_arn,
    "${module.cdn.s3_arn}/*"
  ]
}
