provider "aws" {
  region = var.aws_region
  version = "~> 2.0"
}

data "aws_vpcs" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

locals {
  vpc_id = element(tolist(data.aws_vpcs.vpc.ids), 0)
  name = var.name
  common_tags = {
    terraform = "true"
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = local.vpc_id
}

data "aws_subnet" "subnet0" {
  id = element(tolist(data.aws_subnet_ids.subnets.ids), 0)
}

resource "aws_security_group" "sg" {
  vpc_id = local.vpc_id
  name = var.sg_name


  ingress {
    cidr_blocks = [data.aws_subnet.subnet0.cidr_block]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

data "aws_s3_bucket_object" "userdata" {
  bucket = var.s3_bucket
  key    = var.s3_key_useradata
}

data "aws_s3_bucket_object" "ssh_key_pub" {
  bucket = var.s3_bucket
  key    = var.s3_key_rsa_pub
}

resource "aws_key_pair" "key" {
  key_name   = local.name
  public_key = data.aws_s3_bucket_object.ssh_key_pub.body
}

resource "aws_instance" "vm1" {
  ami = var.ami_id
  
  user_data =  data.aws_s3_bucket_object.userdata.body

  instance_type = var.instance_type
  key_name = aws_key_pair.key.key_name
  subnet_id = data.aws_subnet.subnet0.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
    Name = var.name
  }
}

output "public_ip" {
  value = "${aws_instance.vm1.public_ip}"
}
