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