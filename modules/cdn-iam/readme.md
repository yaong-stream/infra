# Terraform CDN 모듈
CDN User 모듈은 S3에 PutObject를 할 수 있는 AWS IAM User를 생성합니다.

## 요구 사항

- Terraform >= 1.9.7
- hashicorp/aws >= 5.82.2

## variables
name             | type         | default value | required | description 
-----------------|--------------|---------------|----------|------------------------------------------
target_resources | list(string) | X             | O        | AWS S3 arn 리소스 목록
policy_name      | string       | X             | O        | 생성할 aws iam policy 명
uploader         | string       | X             | O        | 생성할 aws iam 유저 명

## outputs
name                   | type   | description 
-----------------------|--------|-------------------------
s3_uploader_access_key | string | 생성된 aws iam access key
s3_uploader_secret_key | string | 생성된 aws iam secret key

## 사용 방법

```hcl
module "cdn_user" {
  source      = "./modules/cdn-iam"
  policy_name = "yaong_cotents"
  uploader    = "yaong_cotents"
  target_resources = [
    module.cdn.s3_arn,
    "${module.cdn.s3_arn}/*"
  ]
}
```
