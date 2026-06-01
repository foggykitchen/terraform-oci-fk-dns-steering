output "zone" {
  value = module.dns_steering.zone
}

output "steering_policy" {
  value = module.dns_steering.steering_policy
}

output "steering_policy_attachment_id" {
  value = module.dns_steering.steering_policy_attachment_id
}

output "health_check_monitor_id" {
  value = module.dns_steering.health_check_monitor_id
}
