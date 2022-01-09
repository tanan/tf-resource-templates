module "default_static_site" {
  source = "./modules/static_site"

  site_domain         = "default-front"
  origin_id           = "s3-origin-default-front"
  acm_certificate_arn = aws_acm_certificate.www_default_domain.arn
  aliases             = "<aliases>"
}
