
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map

locals {
	cloud-run-url-map-project	= "${google_compute_network.gcp_vpc_network.project}"
	cloud-run-url-map-network	= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-url-map-name		= "cloud-run-url-map"
}

resource "google_compute_url_map" "cloud-run-url-map" {
	project		= "${local.cloud-run-url-map-project}"
	name		= "${local.cloud-run-url-map-name}"
	description	= "The cloud-run URL map"
	default_service	= "${google_compute_backend_service.cloud-run-backend-service.id}"
}

