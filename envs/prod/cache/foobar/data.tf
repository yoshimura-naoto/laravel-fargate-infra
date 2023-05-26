data "terraform_remote_state" "network_main" {
  backend = "s3"

  config = {
    bucket = "naotoyoshimura-tfstate"
    key = "example/prod/network/main_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}
