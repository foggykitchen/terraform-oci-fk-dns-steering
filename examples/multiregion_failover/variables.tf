variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "home_region" {
  type    = string
  default = null
}

variable "compartment_id" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null
}

variable "compartment_ocid" {
  type    = string
  default = null
}

variable "availability_domain" {
  type    = string
  default = null
}

variable "zone_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "anchor_record_address" {
  type    = string
  default = null
}

variable "endpoints" {
  description = "Public regional endpoints to steer between."
  type = list(object({
    name   = string
    region = string
    ip     = string
    pool   = optional(string)
  }))
}
