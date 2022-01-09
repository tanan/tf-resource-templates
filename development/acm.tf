resource aws_acm_certificate www_default_domain {
  domain_name       = "www.${aws_route53_zone.default_domain.name}"
  validation_method = "DNS"
  provider          = aws.virginia
}

resource aws_route53_record www_cert_validation {
  for_each = {
    for dvo in aws_acm_certificate.www_default_domain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id = aws_route53_zone.default_domain.zone_id
}

resource aws_acm_certificate_validation www_cert {
  certificate_arn         = aws_acm_certificate.www_default_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.www_cert_validation : record.fqdn]
  provider                = aws.virginia
}

resource aws_acm_certificate api_default_domain {
  domain_name       = "api.${aws_route53_zone.default_domain.name}"
  validation_method = "DNS"
}

resource aws_route53_record api_cert_validation {
  for_each = {
    for dvo in aws_acm_certificate.api_default_domain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id = aws_route53_zone.default_domain.zone_id
}

resource aws_acm_certificate_validation api_cert {
  certificate_arn         = aws_acm_certificate.api_default_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert_validation : record.fqdn]
}
