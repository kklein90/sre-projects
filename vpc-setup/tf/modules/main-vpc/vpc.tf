resource "aws_vpc" "vpc_01" {
  tags = {
    Name       = var.vpc-01-name
    env        = var.env
    account    = var.account
    owner      = "sre"
    management = "terraform"
    service    = "infra"
  }

  cidr_block           = var.vpc-01-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

output "aws-vpc-id" {
  value = aws_vpc.vpc_01.id
}

output "aws-vpc-cidr" {
  value = aws_vpc.vpc_01.cidr_block
}
