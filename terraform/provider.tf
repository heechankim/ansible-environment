terraform {
  backend "s3" {
    bucket = "terraform-remote-state-heechankim"
    key    = "ansible-environment/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "aws_caller_identity" "current" {}