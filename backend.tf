terraform {
  backend "s3" {
    bucket = "my-remote-bucket-one"
    key    = "project/my-terraform"
    region = "us-east-2"

  }




}
