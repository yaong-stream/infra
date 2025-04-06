# Terraform CDN 모듈
CDN 모듈은 Cloudflare를 DNS로 사용하는 AWS 상에서 Cloudfront + S3 조합으로 CDN를 구축하는 기능을 제공합니다.

## 요구 사항

- Terraform >= 1.9.7
- hashicorp/aws >= 5.82.2
- cloudflare/cloudflare == 4.49.1

cloudflare의 경우 5.x 버전 이상의 경우 현재 베타이며, allow_overwrite 기능이 제공되지 않아서 배포에 실패합니다.

## variables
name                    | type   | default value | required | description 
------------------------|--------|---------------|----------|------------------------------------------
bucket_name             | string | X             | O        | S3 버킷 이름
zone_id                 | string | X             | O        | cloudflare에서 제공하는 dns zone id
domain_name             | string | X             | O        | 루트 도메인 주소, 모든 서브 도메인에 cors 적용
fqdn_domain_name        | string | X             | O        | cdn에 연결될 fqdn 도메인 주소
aws_acm_certificate_arn | string | X             | O        | aws us-east-1에서 발급 받은 acm arn

## outputs
name   | type   | description 
-------|--------|-------------
s3_arn | string | 생성된 s3 arn

## 사용 방법

```hcl
module "cdn" {
  source                  = "./modules/cdn"
  bucket_name             = "yaong-content"
  domain_name             = "narumir.io"
  fqdn_domain_name        = "cdn.narumir.io"
  zone_id                 = var.cloudflare_zone_id
  aws_acm_certificate_arn = module.global_acm.aws_acm_certificate_arn
}
```
