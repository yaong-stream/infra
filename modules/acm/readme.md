# Terraform ACM 모듈
ACM 모듈은 Cloudflare를 DNS로 사용하는 AWS 상에서 사용할 수 있는 TLS 인증서를 발급받는 기능을 제공합니다.

## 요구 사항

- Terraform >= 1.9.7
- hashicorp/aws >= 5.82.2
- cloudflare/cloudflare == 4.49.1

cloudflare의 경우 5.x 버전 이상의 경우 현재 베타이며, allow_overwrite 기능이 제공되지 않아서 배포에 실패합니다.

## variables
name        | type   | default value | required | description 
------------|--------|---------------|----------|------------------------------
domain_name | string | X             | O        | 인증서를 발급 받을 도메인 주소 
zone_id     | string | X             | O        | cloudflare에서 제공하는 dns zone id

## outputs
name                    | type         | description 
------------------------|--------------|------------------------------
aws_acm_records         | list(string) | DNS 인증에 사용된 record 목록
aws_acm_certificate_arn | string       | 발급된 acm arn

## 사용 방법

```hcl
module "global_acm" {
  source      = "./modules/acm"
  domain_name = "narumir.io"
  zone_id     = var.cloudflare_zone_id
  providers = {
    aws        = aws.global
    cloudflare = cloudflare
  }
}
```
