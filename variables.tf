variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "The domain name managed in Cloudflare (e.g. example.com)"
  type        = string
}

variable "dns_records" {
  description = "Map of DNS records to create"
  type = map(object({
    type     = string
    name     = string
    content  = string
    ttl      = optional(number, 1) # 1 = automatic
    proxied  = optional(bool, false)
    priority = optional(number, null)
  }))
  default = {}
}

variable "scaleway_access_key" {
  description = "Scaleway access key"
  type        = string
  sensitive   = true
}

variable "scaleway_secret_key" {
  description = "Scaleway secret key"
  type        = string
  sensitive   = true
}

variable "scaleway_project_id" {
  description = "Scaleway project ID"
  type        = string
}

variable "scaleway_organization_id" {
  description = "Scaleway organization ID"
  type        = string
}

variable "scaleway_user_id" {
  description = "Scaleway user ID for bucket policy"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3-compatible backup bucket"
  type        = string
}

variable "email_routes" {
  description = "Map of emails to reroute"
  type = map(object({
    to     = string
    target = string
  }))
}