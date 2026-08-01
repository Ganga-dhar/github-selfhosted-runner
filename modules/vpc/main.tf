
##1 VPC
##1 IGW
##3 Public Subnets
##3 Private Subnets
##1 NAT Gateway
##1 EIP
##2 Route Tables
##6 Route Associations






resource "aws_vpc" "this" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

####################
# Internet Gateway
####################

resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

####################
# Public Subnets
####################

resource "aws_subnet" "public" {

  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"

    Tier = "public"
  }
}

####################
# Private Subnets
####################

resource "aws_subnet" "private" {

  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"

    Tier = "private"
  }
}

####################
# Elastic IP
####################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

####################
# NAT Gateway
####################

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-nat"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

####################
# Public Route Table
####################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

####################
# Private Route Table
####################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

####################
# Public Associations
####################

resource "aws_route_table_association" "public" {

  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

####################
# Private Associations
####################

resource "aws_route_table_association" "private" {

  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}