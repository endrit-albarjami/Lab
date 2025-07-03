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

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block # Use the variable here!

  tags = {
    "Name" = "Main VPC"
  }
}

resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet # Use the variable here!
  availability_zone = "eu-central-1a" # Ensure this matches your region's AZ, or make it a variable too
  tags = {
    "Name" = "Web Subnet"
  }
}
