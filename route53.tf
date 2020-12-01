resource "aws_route53_record" "main" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.MyHttpProxy.zone_id

  alias {
	name                   = aws_cloudfront_distribution.MyHttpProxy.domain_name
	zone_id                = aws_cloudfront_distribution.MyHttpProxy.hosted_zone_id
	evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.MyHttpProxy.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
	name                   = aws_route53_record.main.name
	zone_id                = data.aws_route53_zone.MyHttpProxy.zone_id
	evaluate_target_health = true
  }
}
