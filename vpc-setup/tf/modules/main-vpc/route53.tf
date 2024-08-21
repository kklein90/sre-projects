resource "aws_route53_zone" "sre_zone" {
  name = "sreproject.local"
  vpc {
    vpc_id     = aws_vpc.vpc_01.id
    vpc_region = "us-east-1"
  }
}
