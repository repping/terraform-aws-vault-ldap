# VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = local.tags
}

# Lookup the available AZ's 
data "aws_availability_zones" "default" {
  state = "available"
}

# Public subnets
resource "aws_subnet" "public-1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.default.names[0]

  tags = local.tags
}

resource "aws_subnet" "public-2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = data.aws_availability_zones.default.names[1]

  tags = local.tags
}

resource "aws_subnet" "public-3" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = data.aws_availability_zones.default.names[2]

  tags = local.tags
}

# Private subnets
resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"

  tags = local.tags
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"

  tags = local.tags
}

resource "aws_subnet" "private-3" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.3.0/24"

  tags = local.tags
}

# Internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = local.tags
}

# Routing
resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = aws_vpc.default.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = local.tags
}

# Create an EIP for the NAT Gateway
resource "aws_eip" "default" {
  domain = "vpc"

  tags = local.tags
}

# Create a NAT Gateway
resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id     = aws_subnet.public-1.id
  depends_on    = [aws_internet_gateway.default]

  tags = local.tags
}

