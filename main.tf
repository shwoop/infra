provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zone" "this" {
  name = var.domain
}

module "dns" {
  source = "./modules/dns"

  zone_id     = data.cloudflare_zone.this.id
  dns_records = var.dns_records
}

module "email" {
  source = "./modules/email"

  zone_id      = data.cloudflare_zone.this.id
  account_id   = data.cloudflare_zone.this.account_id
  domain       = var.domain
  email_routes = var.email_routes
}

moved {
  from = cloudflare_record.this
  to   = module.dns.cloudflare_record.this
}

moved {
  from = cloudflare_email_routing_rule.alistair
  to   = module.email.cloudflare_email_routing_rule.this
}

moved {
  from = cloudflare_email_routing_catch_all.this
  to   = module.email.cloudflare_email_routing_catch_all.this
}
