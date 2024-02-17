# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group

locals {
	//Make sure these are set for this machine
    cloud-run-neg-name              = "cloud-run-network-endpoint-group"
    cloud-run-service-neg-description	= "A network endpoint group for the Cloud Run Service on the ${local.cloud-run-service-subnetwork-name} subnet"
}

resource "google_compute_region_network_endpoint_group" "cloud-run-network-endpoint-group" {
    project                 = "${var.project}"
    region                  = "${var.region}"
    name                    = "${local.cloud-run-neg-name}"
    network_endpoint_type   = "SERVERLESS"
    cloud_run {
        service = "${google_cloud_run_v2_service.cloud-run-service.name}"
    }

}
