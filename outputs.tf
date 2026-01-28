output "zone_id" {
  description = "The Cloudflare zone ID"
  value       = data.cloudflare_zone.this.id
}

output "dns_records" {
  description = "Created DNS records"
  value       = module.dns.dns_records
}
