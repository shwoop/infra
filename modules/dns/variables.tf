variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "dns_records" {
  description = "Map of DNS records to create"
  type = map(object({
    type     = string
    name     = string
    content  = string
    ttl      = optional(number, 1)
    proxied  = optional(bool, false)
    priority = optional(number, null)
  }))
  default = {}
}
