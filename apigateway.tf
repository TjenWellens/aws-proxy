resource "aws_apigatewayv2_api" "MyHttpProxy" {
  name = var.domain_name
  description = "proxy to ${var.proxy_target_base}"
  protocol_type = "HTTP"

  //  // cant use 'quick create', because we need a mapping
  //  target = "${var.proxy_target_base}/{proxy}"
  //  // cant use 'quick create', because we need a mapping
  //  route_key = "ANY /{proxy+}"

  tags = var.tags
}

// Needs mapping to work
resource "aws_apigatewayv2_api_mapping" "MyHttpProxy" {
  api_id = aws_apigatewayv2_api.MyHttpProxy.id
  domain_name = aws_apigatewayv2_domain_name.MyHttpProxy.id
  stage = aws_apigatewayv2_stage.MyHttpProxy.id
}

// We cant use 'quick create', because we need a mapping.
// A mapping needs a stage, and we can't reference a 'quick create' stage
//
// aws_apigatewayv2_api.target docs mention:
// Quick create produces an API with an integration, a default catch-all route,
// and a default stage which is configured to automatically deploy changes.
// For HTTP integrations, specify a fully qualified URL.
// For Lambda integrations, specify a function ARN.
// The type of the integration will be HTTP_PROXY or AWS_PROXY, respectively.
// Applicable for HTTP APIs.
resource "aws_apigatewayv2_integration" "MyHttpProxy" {
  api_id = aws_apigatewayv2_api.MyHttpProxy.id
  integration_type = "HTTP_PROXY"
  integration_uri = "${var.proxy_target_base}/{proxy}"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "MyHttpProxy" {
  api_id = aws_apigatewayv2_api.MyHttpProxy.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.MyHttpProxy.id}"
}

resource "aws_apigatewayv2_stage" "MyHttpProxy" {
  api_id = aws_apigatewayv2_api.MyHttpProxy.id
  name = "$default"
  auto_deploy = true
  //  //not allowed because auto_deploy = true
  //  deployment_id = aws_apigatewayv2_deployment.MyHttpProxy.id
  tags = var.tags
}
////not needed because auto_deploy = true
//resource "aws_apigatewayv2_deployment" "MyHttpProxy" {
//  api_id      = aws_apigatewayv2_route.MyHttpProxy.api_id
//  description = "MyHttpProxy deployment"
//
//  lifecycle {
//	create_before_destroy = true
//  }
//
//  depends_on = [aws_apigatewayv2_route.MyHttpProxy]
//}
