# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_resource "oci_dns_rrset" {
    defaults = { "id" = "MOCK_OCID_RRSET" }
  }
  mock_resource "oci_dns_steering_policy" {
    defaults = { "id" = "MOCK_OCID_POLICY", "self" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_dns_steering_policy_attachment" {
    defaults = { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_ATTACHMENT", "rtypes" = ["mock-value"], "self" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_dns_zone" {
    defaults = { "dnssec_config" = [{ "ksk_dnssec_key_versions" = [{ "algorithm" = "mock-value", "ds_data" = [], "key_tag" = 1, "length_in_bytes" = 1, "predecessor_dnssec_key_version_uuid" = "mock-value", "successor_dnssec_key_version_uuid" = "mock-value", "time_activated" = "mock-value", "time_created" = "mock-value", "time_expired" = "mock-value", "time_inactivated" = "mock-value", "time_promoted" = "mock-value", "time_published" = "mock-value", "time_unpublished" = "mock-value", "uuid" = "mock-value" }], "zsk_dnssec_key_versions" = [{ "algorithm" = "mock-value", "key_tag" = 1, "length_in_bytes" = 1, "predecessor_dnssec_key_version_uuid" = "mock-value", "successor_dnssec_key_version_uuid" = "mock-value", "time_activated" = "mock-value", "time_created" = "mock-value", "time_expired" = "mock-value", "time_inactivated" = "mock-value", "time_promoted" = "mock-value", "time_published" = "mock-value", "time_unpublished" = "mock-value", "uuid" = "mock-value" }] }], "id" = "MOCK_OCID_ZONE", "is_protected" = false, "nameservers" = [{ "hostname" = "mock-value" }], "self" = "mock-value", "serial" = 1, "state" = "AVAILABLE", "time_created" = "mock-value", "version" = "mock-value", "zone_transfer_servers" = [{ "address" = "mock-value", "is_transfer_destination" = false, "is_transfer_source" = false, "port" = 1 }] }
  }
  mock_resource "oci_health_checks_http_monitor" {
    defaults = { "home_region" = "mock-value", "id" = "MOCK_OCID_MONITOR", "results_url" = "mock-value", "time_created" = "mock-value" }
  }
}
variables {
  compartment_id = "MOCK_OCID_COMPARTMENT"
  display_name   = "compatibility"
  answers        = [{ "name" = "primary", "rdata" = "192.0.2.10", "rtype" = "A" }]
  zone_name      = "example.test"
  domain_name    = "example.test"
}

run "oci9_plan" {
  command = plan
}
