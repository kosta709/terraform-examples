
sg_name  = "sec-group-b"

sg_ssh_allowed_reference = {
  s3_backend = {
    bucket = "cfterraformtest123"
    key = "example-resource-from-other-state/state-a"
    region = "us-west-2"
  }
  output_ref = "sg_id"
}
