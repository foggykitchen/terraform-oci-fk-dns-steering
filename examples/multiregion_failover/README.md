# Multiregion Failover Example

This example shows a simple OCI multiregion DNS failover setup built on top of `terraform-oci-fk-dns-steering`.

It creates:

- a public DNS zone
- a steering policy using the `FAILOVER` template
- a steering policy attachment for the target domain
- an HTTP health check monitor over the regional public endpoints
- an optional anchor `A` record for safer policy recreation windows

## Inputs

- `zone_name`: DNS zone to create, for example `example.com`
- `domain_name`: fully qualified record name, for example `app.example.com`
- `endpoints`: list of regional public IPs to steer between

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
```

## Notes

- this example assumes your regional entry points already exist, for example public load balancers, API Gateways, or reserved public IPs
- steering resources should normally be created from the tenancy home region

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../../LICENSE) for details.

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
