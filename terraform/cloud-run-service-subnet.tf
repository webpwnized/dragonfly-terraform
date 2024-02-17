
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

locals {
	cloud-run-service-subnet-project	= "${google_compute_network.gcp_vpc_network.project}"
	cloud-run-service-subnet-region	= "${var.region}"
	cloud-run-service-subnet-network	= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-service-subnet-name		= "cloud-run-service-subnet"
	cloud-run-service-subnet-description	= "VPC subnet to deploy Cloud Run Services"
	
	cloud-run-service-subnet-ip-address-range	= "${var.cloud-run-service-subnet-ip-address-range}"
}

resource "google_compute_subnetwork" "gcp-vpc-cloud-run-service-subnetwork" {
	project		= "${local.cloud-run-service-subnet-project}"
	region		= "${local.cloud-run-service-subnet-region}"
	network		= "${local.cloud-run-service-subnet-network}"
	name		= "${local.cloud-run-service-subnet-name}"
	description	= "${local.cloud-run-service-subnet-description}"

	ip_cidr_range	= "${local.cloud-run-service-subnet-ip-address-range}"
	private_ip_google_access	= "true"
	
	log_config {
		aggregation_interval	= "INTERVAL_5_SEC"
		flow_sampling		= "0.25"
		metadata		= "INCLUDE_ALL_METADATA"
		filter_expr		= "true"
	}
}

output "cloud-run-service-subnetwork-gateway-address" {
	value 		= "${google_compute_subnetwork.gcp-vpc-cloud-run-service-subnetwork.gateway_address}"
	description	= "The gateway address for default routes to reach destination addresses outside this subnetwork"
}
