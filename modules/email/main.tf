resource "cloudflare_email_routing_rule" "this" {
  for_each = var.email_routes

  zone_id = var.zone_id
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

resource "cloudflare_email_routing_address" "this" {
  for_each = var.email_routes

  account_id = var.account_id
  email      = each.value.target
}

resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = var.zone_id
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
