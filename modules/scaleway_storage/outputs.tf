output "bucket_name" {
  description = "Name of the backup bucket"
  value       = scaleway_object_bucket.this.name
}

output "bucket_endpoint" {
  description = "S3 endpoint URL for the bucket"
  value       = scaleway_object_bucket.this.endpoint
}

output "access_key" {
  description = "Access key for backup bucket access"
  value       = scaleway_iam_api_key.backup.access_key
}

output "secret_key" {
  description = "Secret key for backup bucket access"
  value       = scaleway_iam_api_key.backup.secret_key
  sensitive   = true
}
