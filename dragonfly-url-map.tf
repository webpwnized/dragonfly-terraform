
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map

locals {
	dragonfly-url-map-project	= "${google_compute_network.gcp_vpc_network.project}"
	dragonfly-url-map-network	= "${google_compute_network.gcp_vpc_network.name}"
	dragonfly-url-map-name		= "${var.dragonfly-application-name}-url-map"
}

resource "google_compute_url_map" "dragonfly-url-map" {
	project		= "${local.dragonfly-url-map-project}"
	name		= "${local.dragonfly-url-map-name}"
	description	= "The ${var.dragonfly-application-name} URL map"
	default_service	= "${google_compute_backend_service.dragonfly-backend-service.id}"
}

