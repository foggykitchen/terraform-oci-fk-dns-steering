output "zone" {
  description = "DNS zone created or targeted by the module."
  value = {
    id   = local.zone_id
    name = var.create_zone ? oci_dns_zone.this[0].name : var.zone_name
  }
}

output "steering_policy" {
  description = "Steering policy details."
  value = {
    id           = oci_dns_steering_policy.this.id
    display_name = oci_dns_steering_policy.this.display_name
    template     = oci_dns_steering_policy.this.template
  }
}

output "steering_policy_attachment_id" {
  description = "Steering policy attachment OCID, if created."
  value       = try(oci_dns_steering_policy_attachment.this[0].id, null)
}

output "health_check_monitor_id" {
  description = "Health check monitor OCID used by the steering policy."
  value       = local.effective_monitor_id
}

output "anchor_record_address" {
  description = "Default anchor A record address, if created."
  value       = var.anchor_record_address
}
