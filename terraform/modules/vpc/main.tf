data "aws_availability_zones" "available" {}

resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc-name
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_sub_name}-${count.index + 1}"
    Env  = var.env
  }

  depends_on = [aws_vpc.app_vpc,
  ]
}

resource "aws_subnet" "private-subnet" {
  count                   = var.private-subnet-count
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index + var.private-subnet-count)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.private_sub_name}-${count.index + 1}"
    Env  = var.env
  }

  depends_on = [aws_vpc.app_vpc,
  ]
}
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = var.igw-name
    Env  = var.env
  }

  depends_on = [aws_vpc.app_vpc]
}

resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = var.public-rt-name
    env  = var.env
  }

  depends_on = [aws_vpc.app_vpc]
}

resource "aws_route_table_association" "app_route_table_assoc" {
  count          = var.public_subnet_count # Associates the route table with each subnet
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.app_route_table.id

  depends_on = [aws_vpc.app_vpc,
    aws_subnet.public_subnet
  ]
}

resource "aws_eip" "ngw-eip" {
  tags = {
    Name = var.eip-name
  }

  depends_on = [aws_vpc.app_vpc
  ]

}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = var.ngw-name
  }

  depends_on = [aws_vpc.app_vpc,
    aws_eip.ngw-eip
  ]
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = var.private-rt-name
    env  = var.env
  }

  depends_on = [aws_vpc.app_vpc,
  ]
}

resource "aws_route_table_association" "private-rt-association" {
  count          = var.private-subnet-count
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)

  depends_on = [aws_vpc.app_vpc,
    aws_subnet.private-subnet
  ]
}
