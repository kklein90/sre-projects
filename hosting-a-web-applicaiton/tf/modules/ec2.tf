resource "aws_instance" "data_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = "us-east-1a"
  key_name                    = aws_key_pair.keypair.key_name
  vpc_security_group_ids      = [aws_security_group.sre_db_server_sg.id]
  subnet_id                   = one([for subnet in data.aws_subnet.public_subnet : subnet.id])
  user_data                   = data.template_file.db_user_data.rendered
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.sre_server_inst_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  tags = {
    Name       = "db_server"
    account    = var.account
    env        = var.env
    management = "terraform"
    service    = "infra"
    owner      = "sre"
  }
}

data "template_file" "db_user_data" {
  template = file("${path.module}/data-user-data.tpl")
  vars = {
    inst_name = "sre-db-svr"
  }
}

resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = "us-east-1a"
  key_name                    = aws_key_pair.keypair.key_name
  vpc_security_group_ids      = [aws_security_group.sre_web_server_sg.id]
  subnet_id                   = one([for subnet in data.aws_subnet.public_subnet : subnet.id])
  user_data                   = data.template_file.web_user_data.rendered
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.sre_server_inst_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  tags = {
    Name       = "web_server"
    account    = var.account
    env        = var.env
    management = "terraform"
    service    = "infra"
    owner      = "sre"
  }
}

data "template_file" "web_user_data" {
  template = file("${path.module}/web-user-data.tpl")
  vars = {
    inst_name = "sre-web-svr"
  }
}

output "db_ip" {
  value = aws_instance.data_server.public_ip
}

output "web_ip" {
  value = aws_instance.web_server.public_ip
}
