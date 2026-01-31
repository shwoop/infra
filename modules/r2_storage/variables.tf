variable "bucket_name" {
  description = "Name of the R2 bucket"
  type        = string
}

variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "location" {
  description = "R2 bucket location hint (WNAM, ENAM, WEUR, EEUR, APAC)"
  type        = string
  default     = "WEUR"
}
