resource "aws_network_acl" "data_tier" {
  vpc_id = aws_vpc.vpc_01.id

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.1.64.0/20"
    from_port  = "5432"
    to_port    = "5432"
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.1.80.0/20"
    from_port  = "5432"
    to_port    = "5432"
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.1.64.0/20"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.1.80.0/20"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl_association" "data_tier_1a" {
  network_acl_id = aws_network_acl.data_tier.id
  subnet_id      = aws_subnet.private_data_subs_01[0].id
}

resource "aws_network_acl_association" "data_tier_1b" {
  network_acl_id = aws_network_acl.data_tier.id
  subnet_id      = aws_subnet.private_data_subs_01[1].id
}
