terraform {
  backend "s3" {
    bucket = "naotoyoshimura-tfstate"
    key = "example/prod/network/main_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}