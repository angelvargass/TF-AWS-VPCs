resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

#SUBNETS CREATION
resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets_cidr[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnets_cidr[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

#ROUTE TABLES CREATION
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.public_rt_name
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.private_rt_name
  }
}

#INTERNET GATEWAY CREATION
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main-igw"
  }
}

#ROUTE TABLES AND IGW ASSOCIATION
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
  gateway_id     = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnets_cidr)
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}
