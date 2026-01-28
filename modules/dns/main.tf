resource "cloudflare_record" "this" {
  for_each = var.dns_records

  zone_id  = var.zone_id
  type     = each.value.type
  name     = each.value.name
  content  = each.value.content
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  priority = each.value.priority
}
