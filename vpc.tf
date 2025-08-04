# VPC
resource "aws_vpc" "lms-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-vpc"
  }
}
# web subnet
resource "aws_subnet" "lms-web-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "lms-web-subnet"
  }
}
# api subnet
resource "aws_subnet" "lms-api-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "lms-api-subnet"
  }
}
# database subnet
resource "aws_subnet" "lms-batabase-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "lms-batabase-subnet"
  }
}
# internet gateway
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-internet-gateway"
  }
}
# lms-public route table 
resource "aws_route_table" "lms-pub-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "lms-public-route"
  }
}

# lms-private route table
resource "aws_route_table" "lms-pvt-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-private-route"
  }
}
# route_table_association_public
resource "aws_route_table_association" "lms-web-asc" {
  subnet_id      = aws_subnet.lms-web-subnet.id
  route_table_id = aws_route_table.lms-pub-rt.id
}
# route_table_association_private
resource "aws_route_table_association" "lms-api-asc" {
  subnet_id      = aws_subnet.lms-api-subnet.id
  route_table_id = aws_route_table.lms-pub-rt.id
}
# route_table_association_private
resource "aws_route_table_association" "lms-batabase-asc" {
  subnet_id      = aws_subnet.lms-batabase-subnet.id
  route_table_id = aws_route_table.lms-pub-rt.id
}
#lms web nacl
resource "aws_network_acl" "web-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}
#lms api nacl
resource "aws_network_acl" "api-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-api-nacl"
  }
}
#lms batabase nacl
resource "aws_network_acl" "batabase-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-batabase-nacl"
  }
}
# lms web nacl association
resource "aws_network_acl_association" "lms-web-nacl-association" {
  network_acl_id = aws_network_acl.web-nacl.id
  subnet_id      = aws_subnet.lms-web-subnet.id

}
# lms api nacl association
resource "aws_network_acl_association" "lms-api-nacl-association" {
  network_acl_id = aws_network_acl.api-nacl.id
  subnet_id      = aws_subnet.lms-api-subnet.id

}
# lms database nacl association
resource "aws_network_acl_association" "lms-database-nacl-association" {
  network_acl_id = aws_network_acl.batabase-nacl.id
  subnet_id      = aws_subnet.lms-database-subnet.id

}