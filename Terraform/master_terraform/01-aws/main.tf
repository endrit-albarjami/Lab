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
  region = "eu-central-1"
  access_keys="AKIA3AASPR34SJ5PT25C"
  secret_key="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"
}



# resource "<provider>_<resource_type>" "local_name" {
#   argument1 = value1
#   argument2 = value2
#   ....
# }

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Main VPC"
  }
 }

