# 개요
yaong 프로젝트에서 사용하는 aws 및 cloudflare 에 대한 Terraform iac 프로젝트입니다.

## 요구 사항
- aws-cli >= 2.15.40
- Terraform >= 1.9.7
- hashicorp/aws >= 5.82.2
- cloudflare/cloudflare == 4.49.1

cloudflare의 경우 5.x 버전 이상의 경우 현재 베타이며, allow_overwrite 기능이 제공되지 않아서 배포에 실패합니다.

## 환경변수 설정

name                        | description
----------------------------|------------------------
TF_VAR_cloudflare_api_token | cloudflare에서 제공하는 api token
TF_VAR_cloudflare_zone_id   | cloudflare에서 제공하는 dns zone id

## 모듈 목록
name                                   | description
---------------------------------------|----------------------------------
[acm](./modules/acm/readme.md)         | aws TLS 인증서 발급 모듈
[cdn](./modules/cdn/readme.md)         | aws cloudflare + S3 기반 cdn 모듈
[cdn iam](./modules/cdn-iam/readme.md) | S3에 PutObject가 가능한 유저 모율

## 디렉토리 구조
```plaintext
project
├── modules/
│   ├── acm/
│   │   ├─── main.tf
│   │   ├─── variables.tf
│   │   ├─── outputs.tf
│   │   ├─── readme.md
│   ├── cdn/
│   ├── cdn_iam/
├─── backend.tf
├─── main.tf
├─── outputs.tf
├─── providers.tf
├─── variables.tf
└─── readme.md
```

* ```modules```       : 재사용 가능한 테라폼 모듈
* ```backend.tf```    : tfstate가 저장되는 backend 설정
* ```main.tf```       : 모듈을 호출
* ```outputs.tf```    : 리소스 outputs
* ```providers.tf```  : 사용하는 providers 설정
* ```variables.tf```  : 사용하는 변수
