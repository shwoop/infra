output "tem_smtp_host" {
  description = "SMTP host for sending transactional emails"
  value       = scaleway_tem_domain.this.smtp_host
}

output "tem_smtp_port" {
  description = "SMTP TLS port"
  value       = scaleway_tem_domain.this.smtp_port
}

output "tem_smtps_auth_user" {
  description = "SMTPS auth user for sending emails"
  value       = scaleway_tem_domain.this.smtps_auth_user
}

output "tem_domain_status" {
  description = "Status of the TEM domain verification"
  value       = scaleway_tem_domain.this.status
}