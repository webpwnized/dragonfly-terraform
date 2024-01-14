
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service

locals {
	cloud-run-backend-service-project	= "${google_compute_network.gcp_vpc_network.project}"
	cloud-run-backend-service-network	= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-backend-service-name		= "cloud-run-backend-service"
}

resource "google_compute_backend_service" "cloud-run-backend-service" {
	project							= "${local.cloud-run-backend-service-project}"
	name							= "${local.cloud-run-backend-service-name}"
	description						= "The Cloud Run backend service"
	timeout_sec						= 60
	connection_draining_timeout_sec	= 30
	enable_cdn						= false
	port_name						= "cloud-run-http-port"
	protocol						= "HTTP"
	load_balancing_scheme			= "EXTERNAL_MANAGED"
	custom_response_headers			= ["Proxied-By: Google Cloud Load Balancer"]
	security_policy					= "${google_compute_security_policy.cloud-armor-security-policy.id}"
	session_affinity				= "GENERATED_COOKIE"
	
	backend {
		group			= "${google_compute_region_network_endpoint_group.cloud-run-network-endpoint-group.id}"
		balancing_mode	= "UTILIZATION"
		max_utilization	= 0.80
	}
	
	health_checks	= ["${google_compute_health_check.cloud-run-health-check.id}"]
	
	log_config {
		enable		= "true"
		sample_rate	= 1.0
	}
}
