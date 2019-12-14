terraform {
  backend "s3" {
    bucket = "cfterraformtest123"
    key    = "examples/vm-user-data-s3/test-1"
    region = "us-west-2"
  }
}