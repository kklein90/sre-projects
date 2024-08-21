data "aws_route53_zone" "srezone" {
  name         = "sreproject.local"
  private_zone = true
}

resource "aws_route53_record" "db" {
  zone_id = data.aws_route53_zone.srezone.zone_id
  name    = "db.sreproject.local"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.data_server.private_ip]
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.srezone.zone_id
  name    = "web.sreproject.local"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web_server.private_ip]
}
