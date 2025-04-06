terraform {
  backend "s3" {
    bucket = "yaong-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}
