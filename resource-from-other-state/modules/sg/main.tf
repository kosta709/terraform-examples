
resource "aws_security_group" "sg_a" {
  vpc_id = var.vpc_id
  name = var.sg_name

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ports_cidrs 
    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = {
    Name = var.sg_name
  }
}



