// the zone should have been created in the previous step
data "aws_route53_zone" "MyHttpProxy" {
  name         = var.domain_name
  private_zone = false
  depends_on = [aws_route53_zone.primary]
}
