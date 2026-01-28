resource "scaleway_tem_domain" "this" {
  name       = var.domain
  accept_tos = true
}

resource "cloudflare_record" "tem_spf" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  content = "v=spf1 include:_spf.mx.cloudflare.net include:_spf.tem.scaleway.com ~all"
  ttl     = 3600
}

resource "cloudflare_record" "tem_dkim" {
  zone_id = var.zone_id
  name    = scaleway_tem_domain.this.dkim_name
  type    = "TXT"
  content = scaleway_tem_domain.this.dkim_config
  ttl     = 3600
}
