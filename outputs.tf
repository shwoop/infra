output "zone_id" {
  description = "The Cloudflare zone ID"
  value       = data.cloudflare_zone.this.id
}

output "dns_records" {
  description = "Created DNS records"
  value       = module.dns.dns_records
}

output "tem_smtp_host" {
  description = "SMTP host for sending transactional emails"
  value       = module.email.tem_smtp_host
}

output "tem_smtp_port" {
  description = "SMTP TLS port"
  value       = module.email.tem_smtp_port
}

output "tem_smtps_auth_user" {
  description = "SMTPS auth user for sending emails"
  value       = module.email.tem_smtps_auth_user
}

output "tem_domain_status" {
  description = "Status of the TEM domain verification"
  value       = module.email.tem_domain_status
}

output "backup_bucket_endpoint" {
  description = "S3 endpoint for the backup bucket"
  value       = module.storage.bucket_endpoint
}

output "backup_access_key" {
  description = "Access key for backup bucket"
  value       = module.storage.access_key
}

output "backup_secret_key" {
  description = "Secret key for backup bucket"
  value       = module.storage.secret_key
  sensitive   = true
}