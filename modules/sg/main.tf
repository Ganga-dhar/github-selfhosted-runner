resource "aws_security_group" "runner" {

  name        = "${var.project_name}-${var.environment}-runner-sg"
  description = "GitHub Self Hosted Runner Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-runner-sg"
  }
}

#####################################################
# SSH
#####################################################

resource "aws_vpc_security_group_ingress_rule" "ssh" {

  count = length(var.allowed_ssh_cidr) > 0 ? 1 : 0

  security_group_id = aws_security_group.runner.id

  from_port = 22
  to_port   = 22

  ip_protocol = "tcp"

  cidr_ipv4 = var.allowed_ssh_cidr[0]

  description = "SSH"
}

#####################################################
# HTTPS OUTBOUND
#####################################################

resource "aws_vpc_security_group_egress_rule" "https" {

  security_group_id = aws_security_group.runner.id

  from_port = 443
  to_port   = 443

  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}

#####################################################
# HTTP OUTBOUND
#####################################################

resource "aws_vpc_security_group_egress_rule" "http" {

  security_group_id = aws_security_group.runner.id

  from_port = 80
  to_port   = 80

  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}

