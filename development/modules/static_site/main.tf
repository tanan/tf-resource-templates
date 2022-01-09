resource "aws_s3_bucket" "static_site" {
  bucket = var.site_domain
  acl    = "private"
}

data "aws_iam_policy_document" "s3_site_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.static_site.iam_arn]
    }
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = [
      "${aws_s3_bucket.static_site.arn}",
      "${aws_s3_bucket.static_site.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:user/default-front-s3"]
    }
    sid = "circleci"
  }
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.s3_site_policy.json
}

resource "aws_cloudfront_origin_access_identity" "static_site" {
  comment = var.site_domain
}

resource "aws_cloudfront_distribution" "static_site" {
  origin {

    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_site.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.site_domain
  default_root_object = "index.html"

  aliases = ["${var.aliases}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_caching_min_ttl = 60
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 60
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  # Change to own domain ssl certification after route53 and acm settings
  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.cloudfront_default_certificate
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }
}

output "domain_name" {
  value = aws_cloudfront_distribution.static_site.domain_name
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.static_site.hosted_zone_id
}