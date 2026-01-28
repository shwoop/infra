resource "cloudflare_email_routing_rule" "alistair" {
  for_each = var.email_routes

  zone_id = data.cloudflare_zone.this.id
  name    = each.value.to
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "${each.value.to}@${var.domain}"
  }

  action {
    type  = "forward"
    value = [each.value.target]
  }
}

resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = data.cloudflare_zone.this.id
  name    = "catch all"
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "drop"
    value = []
  }
}
