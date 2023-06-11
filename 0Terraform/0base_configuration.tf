provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

##
resource "aws_key_pair" "keypair" {
  public_key = var.public_key
  key_name = "${var.project_name}_keypair"

  tags = {
    Name = "${var.project_name}"
  }
}

#1. create vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.aws_vpc_cidr
   # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_support
  enable_dns_support = true
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_hostnames
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}_vpc"
  }
}

#2. create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}_gw"
  }
}

#3. create custom route table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}_route_table"
  }
}

#4. create a subnet
resource "aws_subnet" "subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.20.20.0/28"
    availability_zone = var.availability_zone_a

    tags = {
      Name = "${var.project_name}_subnet1"
    }
  
}

resource "aws_subnet" "subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.20.20.16/28"
    availability_zone = var.availability_zone_b

    tags = {
      Name = "${var.project_name}_subnet2"
    }
  
}

#5. associate subnet with route table
resource "aws_route_table_association" "mean_rule_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "mean_rule_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route.id
}

###
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.route.id
  gateway_id             = aws_internet_gateway.gw.id
}

#6. creating security group web server
resource "aws_security_group" "webserver" {
  name        = "${var.project_name}_webserver"
  description = "Allow ingress traffic for 80"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name} allow web traffic"
  }
}

#6. creating security group ssh
resource "aws_security_group" "ssh" {
  name        = "${var.project_name}_ssh"
  description = "Allow ingress traffic for ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "ssh from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name} allow ssh traffic"
  }
}

#6 create security group to allow 27017
resource "aws_security_group" "mongo" {
  name        = "${var.project_name}_mongo"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "mongodb protocol"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}allow_mong_port"
  }
}
