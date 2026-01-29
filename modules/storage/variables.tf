variable "bucket_name" {
  description = "Name of the S3-compatible object storage bucket"
  type        = string
}

variable "region" {
  description = "Scaleway region for the bucket"
  type        = string
  default     = "fr-par"
}

variable "lock_retention_days" {
  description = "Number of days to retain objects under COMPLIANCE lock"
  type        = number
  default     = 30
}

variable "project_id" {
  description = "Scaleway project ID"
  type        = string
}

variable "scaleway_user_id" {
  description = "Scaleway user ID for bucket policy"
  type        = string
}
