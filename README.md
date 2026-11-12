# terraform-oci-fk-dns-steering

Reusable Terraform / OpenTofu module for provisioning OCI DNS steering policies, optional health checks, and domain attachments.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

## Used By

This module is used as a building block by the higher-level [FoggyKitchen Landing Zone Orchestrator](https://github.com/foggykitchen/foggykitchen-landing-zone-orchestrator), where it is composed into Azure, OCI, and multicloud landing zone patterns.

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

## Requirements

| Requirement | Version |
|---|---|
| OpenTofu | >= 1.11.0 (tested with 1.11.6) |
| oracle/oci | >= 9.12.1, < 10.0.0 |

## BREAKING: requires OCI provider >= 9.12.1

OCI provider 6.x, 7.x and 8.x are no longer supported. Upgrade all composed modules together, run `tofu init -upgrade`, and review a plan before applying. Existing module inputs, outputs and resource addresses are preserved.

Every embedded example is covered by a plan-only mocked test. CI uses OpenTofu 1.11.6 and exact OCI 9.12.1. Mocked plans verify configuration and expressions; they do not verify tenancy permissions, regional availability or service limits.

Run the same checks locally with `python3 scripts/oci9_check.py --root .` (or an example path). The helper materializes synthetic IDs in a temporary copy. For unpublished integration branches only, `OCI9_ALLOW_UNRELEASED=1` permits an explicitly logged fallback from the proposed tag to `oci-provider-9`; released tags always take precedence. `--modules-dir /path/to/checkouts` tests local migrated dependencies.
