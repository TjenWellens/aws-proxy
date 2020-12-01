resource "aws_route53_record" "main" {
  name    = aws_apigatewayv2_domain_name.MyHttpProxy.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.MyHttpProxy.zone_id

  alias {
	name                   = aws_apigatewayv2_domain_name.MyHttpProxy.domain_name_configuration[0].target_domain_name
	zone_id                = aws_apigatewayv2_domain_name.MyHttpProxy.domain_name_configuration[0].hosted_zone_id
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
