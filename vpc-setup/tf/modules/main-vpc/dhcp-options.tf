resource "aws_vpc_dhcp_options" "vpc1_dhcp" {
  domain_name         = "sreproject.local"
  domain_name_servers = [var.ns-record]

  tags = {
    Name = "sreproject-name-server-opts"
  }

}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.vpc_01.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc1_dhcp.id
}
