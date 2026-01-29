# infra

OpenTofu project for managing infrastructure on Cloudflare and Scaleway.

## What it manages

- **DNS** -- Cloudflare DNS records for the domain
- **Email** -- Inbound routing via Cloudflare and outbound transactional email via Scaleway TEM
- **Storage** -- S3-compatible backup bucket on Scaleway with object lock and IAM credentials

## Prerequisites

- [OpenTofu](https://opentofu.org/docs/intro/install/) >= 1.0
- A Cloudflare account with the domain added
- A Cloudflare API token with **Zone:DNS:Edit**, **Zone:Zone:Read**, and **Zone:Email Routing Rules:Edit** permissions
- A Scaleway account with access key, secret key, project ID, and organisation ID

### Creating a Cloudflare API Token

1. Go to https://dash.cloudflare.com/profile/api-tokens
1. Click **Create Token**
1. Use the **Edit zone DNS** template, or create a custom token with:
   - **Zone / DNS / Edit**
   - **Zone / Zone / Read**
   - **Zone / Email Routing Rules / Edit**
1. Scope it to the specific zone for least-privilege access

## Setup

1. Install the correct version of OpenTofu using [tofuenv](https://github.com/tofuutils/tofuenv):

   ```sh
   tofuenv install
   tofuenv use
   ```

   This reads the version from `.opentofu-version` (currently 1.11.4).

1. Copy the example variables file and fill in your values:

   ```sh
   cp terraform.tfvars.example terraform.tfvars
   ```

1. Edit `terraform.tfvars` with your credentials and configuration. The required variables are:

   | Variable                   | Description                              |
   |----------------------------|------------------------------------------|
   | `cloudflare_api_token`     | Cloudflare API token                     |
   | `domain`                   | Domain name managed in Cloudflare        |
   | `dns_records`              | Map of DNS records to create             |
   | `email_routes`             | Map of email forwarding rules            |
   | `scaleway_access_key`      | Scaleway access key                      |
   | `scaleway_secret_key`      | Scaleway secret key                      |
   | `scaleway_project_id`      | Scaleway project ID                      |
   | `scaleway_organization_id` | Scaleway organisation ID                 |
   | `scaleway_user_id`         | Scaleway user ID (for bucket policy)     |
   | `bucket_name`              | Name for the S3-compatible backup bucket |

   > `terraform.tfvars` is gitignored to avoid committing secrets.

1. Initialise OpenTofu:

   ```sh
   tofu init
   ```

## Usage

Preview changes:

```sh
tofu plan
```

Apply changes:

```sh
tofu apply
```

## DNS records

Records are defined in `terraform.tfvars` under the `dns_records` map. Each entry has a key (used only for tracking in state) and an object describing the record:

```hcl
dns_records = {
  apex_a = {
    type    = "A"
    name    = "@"        # @ = zone apex
    content = "192.0.2.1"
    proxied = true
  }

  www_cname = {
    type    = "CNAME"
    name    = "www"
    content = "example.com"
    proxied = true
  }

  mx = {
    type     = "MX"
    name     = "@"
    content  = "mail.example.com"
    ttl      = 3600
    proxied  = false
    priority = 10
  }
}
```

| Field      | Required | Description                                              |
|------------|----------|----------------------------------------------------------|
| `type`     | yes      | Record type (`A`, `AAAA`, `CNAME`, `MX`, `TXT`, etc.)   |
| `name`     | yes      | Record name (`@` for apex, or a subdomain)               |
| `content`  | yes      | Record value (IP address, hostname, text, etc.)          |
| `ttl`      | no       | TTL in seconds. Defaults to `1` (automatic).             |
| `proxied`  | no       | Whether to proxy through Cloudflare. Defaults to `false`.|
| `priority` | no       | Record priority (for MX records, etc.). Defaults to none.|

## Email routing

Email forwarding rules are defined in `terraform.tfvars` under the `email_routes` map:

```hcl
email_routes = {
  alistair = {
    to     = "alistair@example.com"
    target = "destination@gmail.com"
  }
}
```

Unmatched addresses are dropped by a catch-all rule. Outbound transactional email is handled by Scaleway TEM, which sets up DKIM and SPF records automatically.

## Storage

The storage module creates an S3-compatible object storage bucket on Scaleway with compliance-mode object lock. IAM credentials for the bucket are generated automatically and available as outputs.

## Outputs

After applying, the following outputs are available via `tofu output`:

| Output                   | Description                          |
|--------------------------|--------------------------------------|
| `zone_id`                | Cloudflare zone ID                   |
| `dns_records`            | Created DNS records                  |
| `tem_smtp_host`          | SMTP host for transactional email    |
| `tem_smtp_port`          | SMTP TLS port                        |
| `tem_smtps_auth_user`    | SMTP auth user                       |
| `tem_domain_status`      | TEM domain verification status       |
| `backup_bucket_endpoint` | S3 endpoint for the backup bucket    |
| `backup_access_key`      | Access key for the backup bucket     |
| `backup_secret_key`      | Secret key for the backup bucket     |
