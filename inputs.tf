variable "compartment_id" {
  description = "OCI compartment OCID where DNS steering resources will be created."
  type        = string
}

variable "display_name" {
  description = "Display name for the steering policy."
  type        = string
}

variable "template" {
  description = "Steering policy template. Prefer FAILOVER or LOAD_BALANCE unless you need CUSTOM."
  type        = string
  default     = "FAILOVER"
}

variable "ttl" {
  description = "TTL for DNS answers returned by the steering policy."
  type        = number
  default     = 30
}

variable "answers" {
  description = "Potential answers that can be returned by the steering policy."
  type = list(object({
    name        = string
    rdata       = string
    rtype       = string
    pool        = optional(string)
    is_disabled = optional(bool)
  }))
}

variable "rules" {
  description = "Optional explicit steering rules. Useful for CUSTOM policies or when you want to override template defaults."
  type = list(object({
    rule_type     = string
    description   = optional(string)
    default_count = optional(number)
    default_answer_data = optional(list(object({
      answer_condition = optional(string)
      should_keep      = optional(bool)
      value            = optional(number)
    })), [])
    cases = optional(list(object({
      case_condition = optional(string)
      count          = optional(number)
      answer_data = optional(list(object({
        answer_condition = optional(string)
        should_keep      = optional(bool)
        value            = optional(number)
      })), [])
    })), [])
  }))
  default = []
}

variable "health_check" {
  description = "Optional HTTP health check monitor definition. If null, no monitor is created."
  type = object({
    display_name        = optional(string)
    interval_in_seconds = optional(number, 30)
    protocol            = optional(string, "HTTP")
    port                = optional(number)
    method              = optional(string)
    path                = optional(string)
    timeout_in_seconds  = optional(number)
    targets             = list(string)
  })
  default = null
}

variable "health_check_monitor_id" {
  description = "Existing OCI Health Check monitor OCID. Use this instead of health_check when you already have a monitor."
  type        = string
  default     = null
}

variable "create_zone" {
  description = "Whether the module should create the DNS zone."
  type        = bool
  default     = true
}

variable "zone_name" {
  description = "DNS zone name. Required when create_zone is true."
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Existing zone OCID. Required when create_zone is false."
  type        = string
  default     = null
}

variable "create_attachment" {
  description = "Whether the steering policy should be attached to the domain in the target zone."
  type        = bool
  default     = true
}

variable "attachment_display_name" {
  description = "Display name for the steering policy attachment."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "DNS domain name to attach to the steering policy. Defaults to zone_name."
  type        = string
  default     = null
}

variable "create_anchor_record" {
  description = "Whether to create a default A record for the domain as a safety anchor during steering policy recreation."
  type        = bool
  default     = false
}

variable "anchor_record_address" {
  description = "IP address for the optional default A record."
  type        = string
  default     = null
}

variable "anchor_record_ttl" {
  description = "TTL for the optional default A record."
  type        = number
  default     = 30
}

variable "freeform_tags" {
  description = "Freeform tags applied to supported resources."
  type        = map(string)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags applied to supported resources."
  type        = map(string)
  default     = {}
}
