resource "aws_security_group" "sre_web_server_sg" {
  name        = "Web Sec Group"
  description = "sre-srvecurity group"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "self"
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    description = "internal subnet ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["75.115.2.6/32"]
  }

  ingress {
    description = "sre-port-1"
    from_port   = "8000"
    to_port     = "8000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "sre_db_server_sg" {
  name        = "DB Sec Group"
  description = "sre-srvecurity group"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "self"
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    description = "internal subnet ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["75.115.2.6/32"]
  }

  ingress {
    description = "sre-db-port-1"
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

