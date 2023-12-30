
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_http_health_check
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check

locals {
	dragonfly-health-check-project	= "${google_compute_network.gcp_vpc_network.project}"
	dragonfly-health-check-network	= "${google_compute_network.gcp_vpc_network.name}"
	dragonfly-health-check-name	= "${var.dragonfly-application-name}-health-check"
}

resource "google_compute_health_check" "dragonfly-health-check" {
	project			= "${local.dragonfly-backend-service-project}"
	name			= "${local.dragonfly-health-check-name}"
	description 		= "The ${var.dragonfly-application-name} Health Check"
	check_interval_sec	= 30
	timeout_sec		= 30
	healthy_threshold	= 2
	unhealthy_threshold	= 3
	
	tcp_health_check {
		port_name		= "dragonfly-http-port"
		port_specification	= "USE_NAMED_PORT"
		proxy_header		= "NONE"
	}
	
	log_config {
		enable	= true
	}
}

output "dragonfly-health-check-type" {
	value 		= "${google_compute_health_check.dragonfly-health-check.type}"
	description	= "The type of health check"
}

