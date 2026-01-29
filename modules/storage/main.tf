resource "scaleway_object_bucket" "this" {
  name                = var.bucket_name
  region              = var.region
  project_id          = var.project_id
  object_lock_enabled = true
}

resource "scaleway_object_bucket_lock_configuration" "this" {
  bucket     = scaleway_object_bucket.this.name
  region     = var.region
  project_id = var.project_id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = var.lock_retention_days
    }
  }
}

# --- IAM: dedicated application with bucket-scoped access ---

resource "scaleway_iam_application" "backup" {
  name = "${var.bucket_name}-backup"
}

resource "scaleway_iam_policy" "backup" {
  name           = "${var.bucket_name}-backup"
  application_id = scaleway_iam_application.backup.id

  rule {
    project_ids          = [var.project_id]
    permission_set_names = ["ObjectStorageFullAccess"]
  }
}

resource "scaleway_object_bucket_policy" "backup" {
  bucket     = scaleway_object_bucket.this.name
  region     = var.region
  project_id = var.project_id

  policy = jsonencode({
    Version = "2023-04-17"
    Id      = "backup-policy"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "*"
        Resource  = var.bucket_name
      },
      {
        Sid       = "Scaleway secure statement"
        Effect    = "Allow"
        Principal = { SCW = "user_id:${var.scaleway_user_id}" }
        Action    = "*"
        Resource  = [var.bucket_name, "${var.bucket_name}/*"]
      },
      {
        Sid       = "Backup application access"
        Effect    = "Allow"
        Principal = { SCW = "application_id:${scaleway_iam_application.backup.id}" }
        Action    = "*"
        Resource  = [var.bucket_name, "${var.bucket_name}/*"]
      },
    ]
  })
}

resource "scaleway_iam_api_key" "backup" {
  application_id     = scaleway_iam_application.backup.id
  default_project_id = var.project_id
  description        = "API key for ${var.bucket_name} backup access"
}
