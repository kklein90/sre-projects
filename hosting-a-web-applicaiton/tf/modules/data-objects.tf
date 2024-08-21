variable "vpc-name" {
  type = map(string)
  default = {
    Sandbox    = "sreproject-dev"
    Production = "sreproject-prod"
  }
}

data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["${lookup(var.vpc-name, "${var.account}")}"]
  }
}

# public subnet lookup
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["public"]
  }
  filter {
    name   = "tag:az"
    values = ["us-east-1a"]
  }
}

data "aws_subnet" "public_subnet" {
  for_each = toset(data.aws_subnets.public_subnets.ids)
  id       = each.value
}
