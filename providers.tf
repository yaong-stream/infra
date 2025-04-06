terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.49.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "seoul"
}

provider "aws" {
  region = "us-east-1"
  alias  = "global"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
