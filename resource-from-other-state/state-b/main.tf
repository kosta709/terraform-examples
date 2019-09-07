
variable "sg_ssh_allowed_reference" {}
variable "sg_name" {}

data "aws_vpc" "vpc" {
  default = true
}

data "terraform_remote_state" "sg_ssh_allowed_reference" {
  backend = "s3"
  config = var.sg_ssh_allowed_reference.s3_backend
}

resource "aws_security_group" "sg_b" {
  vpc_id = data.aws_vpc.vpc.id
  name = var.sg_name

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.terraform_remote_state.sg_ssh_allowed_reference.outputs.sec_group_id]
  }

  tags = {
    Name = var.sg_name
  }
}



