
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule

locals {
	cloud-run-forwarding-rule-project	= "${google_compute_network.gcp_vpc_network.project}"
	cloud-run-forwarding-rule-network	= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-forwarding-rule-name	= "cloud-run-forwarding-rule"
}

resource "google_compute_global_forwarding_rule" "cloud-run-forwarding-rule" {
	project			= "${local.cloud-run-forwarding-rule-project}"
	name			= "${local.cloud-run-forwarding-rule-name}"
	description		= "The Cloud Run global forwarding rule"
	target			= "${google_compute_target_http_proxy.cloud-run-target-http-proxy.id}"
	ip_protocol		= "TCP"
	load_balancing_scheme	= "EXTERNAL_MANAGED"
	port_range 		= "${var.http-port}"
}

output "cloud-run-global-load-balancer-ip-address" {
	value = "${google_compute_global_forwarding_rule.cloud-run-forwarding-rule.ip_address}"
}
