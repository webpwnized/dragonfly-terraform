
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule

locals {
	dragonfly-forwarding-rule-project	= "${google_compute_network.gcp_vpc_network.project}"
	dragonfly-forwarding-rule-network	= "${google_compute_network.gcp_vpc_network.name}"
	dragonfly-forwarding-rule-name	= "${var.dragonfly-application-name}-forwarding-rule"
}

resource "google_compute_global_forwarding_rule" "dragonfly-forwarding-rule" {
	project			= "${local.dragonfly-forwarding-rule-project}"
	name			= "${local.dragonfly-forwarding-rule-name}"
	description		= "The ${var.dragonfly-application-name} global forwarding rule"
	target			= "${google_compute_target_http_proxy.dragonfly-target-http-proxy.id}"
	ip_protocol		= "TCP"
	load_balancing_scheme	= "EXTERNAL_MANAGED"
	port_range 		= "${var.http-port}"
}

output "dragonfly-global-load-balancer-ip-address" {
	value = "${google_compute_global_forwarding_rule.dragonfly-forwarding-rule.ip_address}"
}
