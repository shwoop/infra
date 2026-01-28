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

# --- Scaleway Transactional Email (TEM) ---

resource "scaleway_tem_domain" "this" {
  name       = var.domain
  accept_tos = true
}

resource "cloudflare_record" "tem_spf" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  content = scaleway_tem_domain.this.spf_config
  ttl     = 3600
}

resource "cloudflare_record" "tem_dkim" {
  zone_id = var.zone_id
  name    = scaleway_tem_domain.this.dkim_name
  type    = "TXT"
  content = scaleway_tem_domain.this.dkim_config
  ttl     = 3600
}

resource "cloudflare_record" "tem_mx" {
  zone_id  = var.zone_id
  name     = var.domain
  type     = "MX"
  content  = scaleway_tem_domain.this.mx_blackhole
  priority = 10
  ttl      = 3600
}
