
terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket  = "sample-terraform-tfstate"
    key     = "sample/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "sample"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "sample"
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "sample"
}