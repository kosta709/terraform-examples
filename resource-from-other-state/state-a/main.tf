variable "aws_region" {}
variable "sg_name" {}
variable "ports_cidrs" {}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "vpc" {
  default = true
}

module "sg_a" {
  source = "../modules/sg"
  vpc_id = data.aws_vpc.vpc.id
  sg_name = var.sg_name
  ports_cidrs = var.ports_cidrs
}

output "sec_group_id" {
  value = module.sg_a.sec_group_id
}


