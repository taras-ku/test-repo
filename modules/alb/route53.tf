
resource "aws_route53_record" "frontend_primary" {
  zone_id = data.aws_route53_zone.teamfiveproject.zone_id
  name    = join("", var.frontend_host_header)
  type    = "A"

  alias {
    name                   = aws_lb.main_alb.dns_name
    zone_id                = aws_lb.main_alb.zone_id
    evaluate_target_health = true
  }

  set_identifier = "Primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
}


resource "aws_route53_record" "frontend_s3_failover" {
  zone_id = data.aws_route53_zone.teamfiveproject.zone_id
  name    = join("", var.frontend_host_header)
  type    = "A"

  alias {
    name                   = data.aws_s3_bucket.existing_maintenance_page.website_endpoint
    zone_id                = "Z3AQBSTGFYJSTF" #needs to be discussed
    evaluate_target_health = false
  }

  set_identifier = "Secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
}



resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.teamfiveproject.zone_id
  name    = join("", var.backend_host_header)
  type    = "A"

  alias {
    name                   = aws_lb.main_alb.dns_name
    zone_id                = aws_lb.main_alb.zone_id
    evaluate_target_health = false
  }
}
