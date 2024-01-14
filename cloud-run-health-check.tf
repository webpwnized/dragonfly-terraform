
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_http_health_check
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check

locals {
	cloud-run-health-check-project	= "${google_compute_network.gcp_vpc_network.project}"
	cloud-run-health-check-network	= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-health-check-name	= "cloud-run-health-check"
}

resource "google_compute_health_check" "cloud-run-health-check" {
	project			= "${local.cloud-run-backend-service-project}"
	name			= "${local.cloud-run-health-check-name}"
	description 		= "The cloud-run Health Check"
	check_interval_sec	= 30
	timeout_sec		= 30
	healthy_threshold	= 2
	unhealthy_threshold	= 3
	
	tcp_health_check {
		port_name		= "cloud-run-http-port"
		port_specification	= "USE_NAMED_PORT"
		proxy_header		= "NONE"
	}
	
	log_config {
		enable	= true
	}
}

output "cloud-run-health-check-type" {
	value 		= "${google_compute_health_check.cloud-run-health-check.type}"
	description	= "The type of health check"
}

