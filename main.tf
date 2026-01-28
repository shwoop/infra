provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zone" "this" {
  name = var.domain
}

resource "cloudflare_record" "this" {
  for_each = var.dns_records

  zone_id = data.cloudflare_zone.this.id
  type    = each.value.type
  name    = each.value.name
  content = each.value.content
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  priority = each.value.priority
}
