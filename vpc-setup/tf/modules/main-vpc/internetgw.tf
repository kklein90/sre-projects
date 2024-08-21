resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name       = "${var.env}-igw"
    env        = var.env
    account    = var.account
    owner      = "sre"
    management = "terraform"
    service    = "infra"
  }
}
