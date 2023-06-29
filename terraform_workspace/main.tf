/*
 The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision infrastructure.
 Terraform installs providers from the Terraform Registry by default.
 In this example configuration, the aws provider's source is defined as hashicorp/aws,
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  profile = "upes"
  region  = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-05432c5a0f7b1bfd0"
  instance_type = var.env == "prod" ? "t2.micro" : "t2.nano"
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  key_name = "bootcamp"

  depends_on = [
   aws_s3_bucket.data_bucket
  ]

  tags = {
    Name = "Terraform-${var.env}"
    Terraform = "true"
  }
}

resource "aws_security_group" "sg_web" {
  name = "${var.resource_alias}-${var.env}-sg"

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env         = var.env
    Terraform   = true
  }
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.resource_alias}-${var.env}-bucket"

  tags = {
    Name        = "${var.resource_alias}-bucket"
    Env         = var.env
    Terraform   = true
  }
}

module "app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "${var.resource_alias}-tvpc"
  cidr = var.vpc_cidr

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = true

  tags = {
    Name        = "${var.resource_alias}-tvpc"
    Env         = var.env
    Terraform   = true
  }
}

