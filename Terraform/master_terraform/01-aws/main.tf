terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1" # Ensure this is correct for your desired region
  # REMOVE access_key and secret_key if they are still here!
  # They MUST NOT be committed to Git.
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }
}

resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet # Use the variable here!
  availability_zone = var.subnet_zone # Ensure this matches your region's AZ, or make it a variable too
  tags = {
    "Name" = "Web Subnet"
  }
}

resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }

  tags = {
    "Name" = "my-default-rt"
  }

} 

# Create an Internet Gateway
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My Web Internet Gateway"
  }
}

resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_vm" {
  ami                    = "ami-0af9b40b1a16fe700"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.web.id
  vpc_security_group_ids = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name               = "production_ssh_key"
  tags = {
    "Name" = "My EC2 Instance - Amazon Linux 2"
  }
}
