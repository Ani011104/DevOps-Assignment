#Creating a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-vpc"
  })
}

#Creating an Internet Gateway for the resources to access Net
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-igw"
  })
}

#Creating Public Subnets (2 for ALB)
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-public-a"
  })
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-public-b"
  })
}

#Creating Private Subnets (2 for ECS)
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-private-a"
  })
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-private-b"
  })
}

#Creating Public Route Table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # allowing traffic from anywhere 
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-public-rt"
  })
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
#Creating NAT Gateway for the private subnets , 2 for AZ and HA
resource "aws_eip" "nat_a" {
  domain = "vpc"
}

resource "aws_eip" "nat_b" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id
  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-nat-a"
  })
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id
  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-nat-b"
  })
}

#Creating Private Route Table for the private subnets
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-private-rt"
  })
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

#### might have to add 1 more nat gateway for the second public subnet, due to change in az\

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.Environment}-${var.Project}-private-rt"
  })
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

