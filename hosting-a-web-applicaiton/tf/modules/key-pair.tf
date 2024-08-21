resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "keypair" {
  key_name   = "sre-general-082024"
  public_key = tls_private_key.key.public_key_openssh
}

output "private-key" {
  value = tls_private_key.key.private_key_openssh
}
