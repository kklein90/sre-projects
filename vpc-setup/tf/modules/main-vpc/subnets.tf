data "aws_region" "current-region" {}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subs_01" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_01.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name       = "${var.env}-public-${data.aws_availability_zones.available.names[count.index]}"
    env        = var.env
    account    = var.account
    az         = data.aws_availability_zones.available.names[count.index]
    owner      = "sre"
    management = "terraform"
    service    = "infra"
    usage      = "public"
  }

  lifecycle {
    ignore_changes = [tags.CreationTime]
  }

}

resource "aws_subnet" "private_frontend_subs_01" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_01.cidr_block, 4, count.index + 2)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name       = "${var.env}-frontend-${data.aws_availability_zones.available.names[count.index]}"
    env        = var.env
    account    = var.account
    owner      = "sre"
    management = "terraform"
    service    = "infra"
    usage      = "frontend"
  }

  lifecycle {
    ignore_changes = [tags.CreationTime]
  }

}

resource "aws_subnet" "private_services_subs_01" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_01.cidr_block, 4, count.index + 4)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name       = "${var.env}-services-${data.aws_availability_zones.available.names[count.index]}"
    env        = var.env
    account    = var.account
    owner      = "sre"
    management = "terraform"
    service    = "infra"
    usage      = "services"
  }

  lifecycle {
    ignore_changes = [tags.CreationTime]
  }

}

resource "aws_subnet" "private_data_subs_01" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_01.cidr_block, 4, count.index + 6)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name       = "${var.env}-data-${data.aws_availability_zones.available.names[count.index]}"
    env        = var.env
    account    = var.account
    owner      = "sre"
    management = "terraform"
    service    = "infra"
    usage      = "data"
  }

  lifecycle {
    ignore_changes = [tags.CreationTime]
  }

}
