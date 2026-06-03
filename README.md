# terraform-oci-fk-dns-steering

Reusable Terraform / OpenTofu module for provisioning OCI DNS steering policies, optional health checks, and domain attachments.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).


## What It Covers

- `oci_dns_steering_policy`
- `oci_dns_steering_policy_attachment`
- optional `oci_health_checks_http_monitor`
- optional DNS zone creation
- optional anchor `A` record for safer policy recreation windows

## Common Use Cases

- multiregion failover across regional public endpoints
- weighted load balancing across OCI regions
- attaching a DNS steering policy to an existing public zone

## Example

- [examples/multiregion_failover](examples/multiregion_failover/README.md)

## Usage

```hcl
module "dns_steering" {
  source = "github.com/foggykitchen/terraform-oci-fk-dns-steering"

  compartment_id = var.compartment_id
  display_name   = "fk-multiregion-failover"
  template       = "FAILOVER"
  zone_name      = "example.com"
  domain_name    = "app.example.com"

  answers = [
    {
      name  = "primary"
      rtype = "A"
      rdata = "203.0.113.10"
      pool  = "primary"
    },
    {
      name  = "secondary"
      rtype = "A"
      rdata = "198.51.100.20"
      pool  = "secondary"
    }
  ]

  health_check = {
    targets = [
      "203.0.113.10",
      "198.51.100.20"
    ]
  }
}
```

## Notes

- Oracle recommends using templates such as `FAILOVER` or `LOAD_BALANCE` instead of `CUSTOM` unless you need full rule control.
- If a steering policy recreation is required, Oracle recommends keeping a default DNS record in place for the affected domain. The optional anchor `A` record in this module supports that fallback model.

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
