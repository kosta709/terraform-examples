terraform {
  backend "s3" {
    bucket = "cfterraformtest123"
    key    = "example-resource-from-other-state/state-b"
    region = "us-west-2"
  }
}