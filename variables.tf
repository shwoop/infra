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
    type    = string
    name    = string
    content = string
    ttl      = optional(number, 1) # 1 = automatic
    proxied  = optional(bool, false)
    priority = optional(number, null)
  }))
  default = {}
}

variable "email_routes" {
  description = "Map of emails to reroute"
  type = map(object({
    to = string
    target = string 
  }))
}