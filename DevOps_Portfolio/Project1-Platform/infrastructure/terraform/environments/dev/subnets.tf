# Availability Zones data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  # Required for public subnets
  map_public_ip_on_launch = true

  tags = merge(var.project_tags, {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
    Tier = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.project_tags, {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
    Tier = "Private"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.project_tags, {
    Name = "${var.environment}-igw"
  })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = merge(var.project_tags, {
    Name = "${var.environment}-nat-eip"
  })
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # Place in first public subnet

  tags = merge(var.project_tags, {
    Name = "${var.environment}-nat"
  })

  depends_on = [aws_internet_gateway.main]
}
