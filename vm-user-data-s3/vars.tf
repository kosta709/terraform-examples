
variable aws_region {}

variable name {}
variable vpc_name {}

variable ami_id {}

variable sg_name {}

variable s3_bucket {}
variable s3_key_useradata  {}
variable s3_key_rsa_pub {} 

variable instance_type {
  default = "t2.micro"
}

