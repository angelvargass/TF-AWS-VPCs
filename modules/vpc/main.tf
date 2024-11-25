resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

#SECURITY GROUPS
resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_rule" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ssh_egress_rule" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
}

#SUBNETS CREATION
resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true

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

#INTERNET GATEWAY CREATION
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main-igw"
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

#ROUTE TABLES AND IGW ASSOCIATION
resource "aws_route" "r" {
  route_table_id              = aws_route_table.public_rt.id
  #Allows public internet access
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnets_cidr)
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}
