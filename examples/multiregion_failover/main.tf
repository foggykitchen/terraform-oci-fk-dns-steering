locals {
  effective_compartment_id = coalesce(var.compartment_id, var.compartment_ocid)
}

module "dns_steering" {
  source = "../.."

  compartment_id        = local.effective_compartment_id
  display_name          = "fk-multiregion-failover"
  template              = "FAILOVER"
  zone_name             = var.zone_name
  domain_name           = var.domain_name
  create_anchor_record  = var.anchor_record_address != null
  anchor_record_address = var.anchor_record_address
  ttl                   = 30

  answers = [
    for endpoint in var.endpoints : {
      name  = "endpoint-${endpoint.region}"
      rtype = "A"
      rdata = endpoint.ip
      pool  = try(endpoint.pool, endpoint.region)
    }
  ]

  health_check = {
    display_name = "fk-multiregion-failover-http-monitor"
    targets      = [for endpoint in var.endpoints : endpoint.ip]
  }
}
