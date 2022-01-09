resource "aws_route53_zone" "default_domain" {
  name = "example.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.default_domain.zone_id
  name    = "www"
  type    = "A"
  alias {
    name                   = module.default_static_site.domain_name
    zone_id                = module.default_static_site.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.default_domain.zone_id
  name    = "api"
  type    = "A"
  alias {
    name                   = module.default_pub.domain_name
    zone_id                = module.default_pub.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = aws_route53_zone.default_domain.zone_id
  name    = "${var.stage}-bastion"
  type    = "A"
  records = [module.bastion01.public_ip]
  ttl     = 3600
}
