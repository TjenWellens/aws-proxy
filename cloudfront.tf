locals {
  origin_id = "myOriginId"
}

resource "aws_cloudfront_distribution" "MyHttpProxy" {
  origin {
	custom_origin_config {
	  http_port = 80
	  https_port = 443
	  origin_protocol_policy = "https-only"
	  origin_ssl_protocols = ["TLSv1.2"]
	}
	domain_name = var.proxy_target_domain_name
	origin_id   = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
	allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
	cached_methods   = ["GET", "HEAD"]
	target_origin_id = local.origin_id

	forwarded_values {
	  query_string = false

	  cookies {
		forward = "none"
	  }
	}

	viewer_protocol_policy = "redirect-to-https"
	min_ttl                = 0
	default_ttl            = 0
	max_ttl                = 0
  }

  price_class = "PriceClass_100"

  restrictions {
	geo_restriction {
	  restriction_type = "none"
	}
  }

  tags = var.tags

  viewer_certificate {
	ssl_support_method = "sni-only"
	minimum_protocol_version = "TLSv1.2_2019"
	acm_certificate_arn = aws_acm_certificate.MyHttpProxy.arn
  }
}
