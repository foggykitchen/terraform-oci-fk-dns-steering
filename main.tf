locals {
  zone_id                   = var.create_zone ? oci_dns_zone.this[0].id : var.zone_id
  effective_domain_name     = coalesce(var.domain_name, var.zone_name)
  effective_attachment_name = coalesce(var.attachment_display_name, "${var.display_name}Attachment")
  effective_monitor_id      = var.health_check_monitor_id != null ? var.health_check_monitor_id : try(oci_health_checks_http_monitor.this[0].id, null)
}

resource "oci_health_checks_http_monitor" "this" {
  count = var.health_check == null ? 0 : 1

  compartment_id      = var.compartment_id
  display_name        = coalesce(var.health_check.display_name, "${var.display_name}HttpMonitor")
  interval_in_seconds = var.health_check.interval_in_seconds
  protocol            = var.health_check.protocol
  targets             = var.health_check.targets

  port               = try(var.health_check.port, null)
  method             = try(var.health_check.method, null)
  path               = try(var.health_check.path, null)
  timeout_in_seconds = try(var.health_check.timeout_in_seconds, null)
}

resource "oci_dns_zone" "this" {
  count = var.create_zone ? 1 : 0

  compartment_id = var.compartment_id
  name           = var.zone_name
  zone_type      = "PRIMARY"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource "oci_dns_rrset" "anchor_a_record" {
  count = var.create_anchor_record && var.anchor_record_address != null ? 1 : 0

  zone_name_or_id = local.zone_id
  domain          = local.effective_domain_name
  rtype           = "A"

  items {
    domain = local.effective_domain_name
    rdata  = var.anchor_record_address
    rtype  = "A"
    ttl    = var.anchor_record_ttl
  }
}

resource "oci_dns_steering_policy" "this" {
  compartment_id          = var.compartment_id
  display_name            = var.display_name
  template                = var.template
  ttl                     = var.ttl
  health_check_monitor_id = local.effective_monitor_id
  defined_tags            = var.defined_tags
  freeform_tags           = var.freeform_tags

  dynamic "answers" {
    for_each = var.answers
    content {
      name        = answers.value.name
      rdata       = answers.value.rdata
      rtype       = answers.value.rtype
      pool        = try(answers.value.pool, null)
      is_disabled = try(answers.value.is_disabled, null)
    }
  }

  dynamic "rules" {
    for_each = var.rules
    content {
      rule_type     = rules.value.rule_type
      description   = try(rules.value.description, null)
      default_count = try(rules.value.default_count, null)

      dynamic "default_answer_data" {
        for_each = try(rules.value.default_answer_data, [])
        content {
          answer_condition = try(default_answer_data.value.answer_condition, null)
          should_keep      = try(default_answer_data.value.should_keep, null)
          value            = try(default_answer_data.value.value, null)
        }
      }

      dynamic "cases" {
        for_each = try(rules.value.cases, [])
        content {
          case_condition = try(cases.value.case_condition, null)
          count          = try(cases.value.count, null)

          dynamic "answer_data" {
            for_each = try(cases.value.answer_data, [])
            content {
              answer_condition = try(answer_data.value.answer_condition, null)
              should_keep      = try(answer_data.value.should_keep, null)
              value            = try(answer_data.value.value, null)
            }
          }
        }
      }
    }
  }
}

resource "oci_dns_steering_policy_attachment" "this" {
  count = var.create_attachment ? 1 : 0

  domain_name        = local.effective_domain_name
  display_name       = local.effective_attachment_name
  steering_policy_id = oci_dns_steering_policy.this.id
  zone_id            = local.zone_id
}
