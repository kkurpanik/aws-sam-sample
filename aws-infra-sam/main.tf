terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1"
  access_key = "XXX"
  secret_key = "YYY"
}

resource "aws_vpc" "idmz-vpc" {
    cidr_block = "10.1.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        "Name" = "idmz-vpc"
        "network:zone" = "idmz"
    }
}

resource "aws_subnet" "idmz-private-subnet-a" {
    vpc_id = aws_vpc.idmz-vpc.id
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        "Name" = "idmz-private-subnet-a"
    }
}

resource "aws_ssm_parameter" "idmz-private-subnet-a-id" {
    name = "idmz-private-subnet-a-id"
    type = "String"
    value = aws_subnet.idmz-private-subnet-a.id
}

resource "aws_subnet" "idmz-private-subnet-b" {
    vpc_id = aws_vpc.idmz-vpc.id
    cidr_block = "10.1.2.0/24"
    availability_zone = "us-east-1b"
    
    tags = {
        "Name" = "idmz-private-subnet-b"
    }
}

resource "aws_ssm_parameter" "idmz-private-subnet-b-id" {
    name = "idmz-private-subnet-b-id"
    type = "String"
    value = aws_subnet.idmz-private-subnet-b.id
}

resource "aws_security_group" "idmz-notification-sg" {
    name = "idmz-notification-sg"
    description = "Security group SNS notifications"
    vpc_id = aws_vpc.idmz-vpc.id

    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "Name" = "idmz-notification-sg"
    }
}

resource "aws_ssm_parameter" "idmz-notification-sg-id" {
    name = "idmz-notification-sg-id"
    type = "String"
    value = aws_security_group.idmz-notification-sg.id
}

resource "aws_vpc_endpoint" "idmz-sns-endpoint" {
    vpc_id = aws_vpc.idmz-vpc.id
    service_name = "com.amazonaws.us-east-1.sns"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true

    security_group_ids = [
      aws_security_group.idmz-notification-sg.id,
    ]

    subnet_ids = [
      aws_subnet.idmz-private-subnet-a.id,
      aws_subnet.idmz-private-subnet-b.id,
    ]

    tags = {
        "Name" = "idmz-sns-endpoint"
    }
}
