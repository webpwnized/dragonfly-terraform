
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy

locals {
	dragonfly-target-http-proxy-project	= "${google_compute_network.gcp_vpc_network.project}"
	dragonfly-target-http-proxy-network	= "${google_compute_network.gcp_vpc_network.name}"
	dragonfly-target-http-proxy-name	= "${var.dragonfly-application-name}-target-http-proxy"
}

resource "google_compute_target_http_proxy" "dragonfly-target-http-proxy" {
	project		= "${local.dragonfly-target-http-proxy-project}"
	name		= "${local.dragonfly-target-http-proxy-name}"
	description	= "The ${var.dragonfly-application-name} target HTTP proxy"
	url_map		= "${google_compute_url_map.dragonfly-url-map.id}"
}

