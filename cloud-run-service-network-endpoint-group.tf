# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group

locals {
	// These default values should work without changes
	cloud-run-service-neg-network-name		= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-service-neg-subnetwork-name	= "${google_compute_subnetwork.gcp-vpc-cloud-run-service-subnetwork.name}"
	
	//Make sure these are set for this machine
    cloud-run-neg-name              = "cloud-run-network-endpoint-group"
    cloud-run-service-neg-description	= "A network endpoint group for the Cloud Run Service on the ${local.cloud-run-service-subnetwork-name} subnet"
}

resource "google_compute_region_network_endpoint_group" "cloud-run-network-endpoint-group" {
    project                 = "${var.project}"
    region                  = "${var.region}"
    name                    = "${local.cloud-run-neg-name}"
    network                 = "${local.cloud-run-service-neg-network-name}"
    subnetwork              = "${local.cloud-run-service-neg-subnetwork-name}"
    network_endpoint_type   = "SERVERLESS"
    cloud_run {
        service = "${google_cloud_run_v2_service.cloud-run-service.name}"
    }

}

output "cloud-run-network-endpoint-group-self-link" {
	value		= "${google_compute_region_network_endpoint_group.cloud-run-network-endpoint-group.self_link}"
	description	= "The URI of the created resource."
	sensitive	= "false"
}
