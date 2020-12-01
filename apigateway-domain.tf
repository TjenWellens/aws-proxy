resource "aws_apigatewayv2_domain_name" "MyHttpProxy" {
  domain_name = var.domain_name

  domain_name_configuration {
	certificate_arn = aws_acm_certificate_validation.MyHttpProxy.certificate_arn
	endpoint_type   = "REGIONAL"
	security_policy = "TLS_1_2"
  }
  tags = var.tags
}
