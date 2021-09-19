terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.32.0"
    }
  }
}

provider "aws" {
		region = var.region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name = "Postgres SQL VPC"
  }
}

# Create a Public subnet in AZ 1A
resource "aws_subnet" "Web_Subnet_1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public_Subnet"
  }
}

# Create a Internet Gateway for My-VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Project 1 Internet Gateway"
  }
}


# Create a Custom Route Table for Public Subnet
resource "aws_route_table" "Web-Route-Table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Public Route table"
  }
}

# Create Route Table Association for Public Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Web_Subnet_1a.id
  route_table_id = aws_route_table.Web-Route-Table.id
}

# Create SSH Security Group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


# Create 5432 Security Group
resource "aws_security_group" "allow_5432" {
  name        = "allow_5432"
  description = "Allow 5432 inbound application traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "5432 from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_5432"
  }
}

