terraform {
  backend "s3" {
    bucket = "nf2ewhx"
    key    = "path"
    region = "us-west-2"
  }
}