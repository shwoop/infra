# infra

Terraform project for managing Cloudflare DNS records for `ferguson.fr`.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- A Cloudflare account with the domain added
- A Cloudflare API token with **Zone:DNS:Edit** and **Zone:Zone:Read** permissions

### Creating an API Token

1. Go to https://dash.cloudflare.com/profile/api-tokens
2. Click **Create Token**
3. Use the **Edit zone DNS** template, or create a custom token with:
   - **Zone / DNS / Edit**
   - **Zone / Zone / Read**
4. Scope it to the specific zone (`ferguson.fr`) for least-privilege access

## Setup

1. Copy the example variables file and fill in your values:

   ```sh
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your API token and DNS records.

   > `terraform.tfvars` is gitignored to avoid committing secrets.

3. Initialise Terraform:

   ```sh
   terraform init
   ```

## Usage

Preview changes:

```sh
terraform plan
```

Apply changes:

```sh
terraform apply
```

## Managing DNS Records

Records are defined in `terraform.tfvars` under the `dns_records` map. Each entry has a key (used only for Terraform tracking) and an object describing the record:

```hcl
dns_records = {
  apex_a = {
    type    = "A"
    name    = "@"        # @ = zone apex (ferguson.fr)
    content = "192.0.2.1"
    proxied = true
  }

  www_cname = {
    type    = "CNAME"
    name    = "www"
    content = "ferguson.fr"
    proxied = true
  }

  mx = {
    type    = "MX"
    name    = "@"
    content = "mail.ferguson.fr"
    ttl     = 3600
    proxied = false
  }
}
```

### Field Reference

| Field     | Required | Description                                      |
|-----------|----------|--------------------------------------------------|
| `type`    | yes      | Record type (`A`, `AAAA`, `CNAME`, `MX`, `TXT`, etc.) |
| `name`    | yes      | Record name (`@` for apex, or a subdomain)       |
| `content` | yes      | Record value (IP address, hostname, text, etc.)  |
| `ttl`     | no       | TTL in seconds. Defaults to `1` (automatic).     |
| `proxied` | no       | Whether to proxy through Cloudflare. Defaults to `false`. |
