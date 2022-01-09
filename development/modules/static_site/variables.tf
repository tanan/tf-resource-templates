variable "site_domain" {}
variable "origin_id" {}
variable "acm_certificate_arn" {}
variable "aliases" {}
variable "cloudfront_default_certificate" {
  default = false
}