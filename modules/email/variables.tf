variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "domain" {
  description = "The domain name"
  type        = string
}

variable "email_routes" {
  description = "Map of emails to reroute"
  type = map(object({
    to     = string
    target = string
  }))
}
