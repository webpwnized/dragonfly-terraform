
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy

locals {
	cloud-run-target-http-proxy-project	= "${google_compute_network.gcp_vpc_network.project}"
	cloud-run-target-http-proxy-network	= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-target-http-proxy-name	= "cloud-run-target-http-proxy"
}

resource "google_compute_target_http_proxy" "cloud-run-target-http-proxy" {
	project		= "${local.cloud-run-target-http-proxy-project}"
	name		= "${local.cloud-run-target-http-proxy-name}"
	description	= "The Cloud Run target HTTP proxy"
	url_map		= "${google_compute_url_map.cloud-run-url-map.id}"
}

