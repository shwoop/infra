output "zone_id" {
  description = "The Cloudflare zone ID"
  value       = data.cloudflare_zone.this.id
}

output "dns_records" {
  description = "Created DNS records"
  value = {
    for k, r in cloudflare_record.this : k => {
      hostname = r.hostname
      type     = r.type
      content  = r.content
    }
  }
}
