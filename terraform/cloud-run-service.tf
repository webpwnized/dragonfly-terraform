# https://cloud.google.com/blog/topics/developers-practitioners/serverless-load-balancing-terraform-hard-way
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service

locals {
	// These default values should work without changes
	cloud-run-service-network-name		= "${google_compute_network.gcp_vpc_network.name}"
	cloud-run-service-subnetwork-name	= "${google_compute_subnetwork.gcp-vpc-cloud-run-service-subnetwork.name}"
	
	//Make sure these are set for this machine
    cloud-run-repository-name           = "webpwnized"
    cloud-run-repository-container-name = "dragonfly"
    cloud-run-repository-container-tag  = "www"
    cloud-run-image-location            = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.remote-dockerhub-repository.name}/${local.cloud-run-repository-name}/${local.cloud-run-repository-container-name}:${local.cloud-run-repository-container-tag}"
	cloud-run-service-name 			    = "${var.application-name}-cloud-run-service"
	cloud-run-service-tags 			    = ["cloud-run-service"]
	cloud-run-service-description		= "A jump server to allow access to other IaaS on the ${local.cloud-run-service-subnetwork-name} subnet"
	cloud-run-service-labels 			= "${merge(
                                            tomap({ 
                                                "purpose"	= "cloud-run-service",
                                                "asset-type"	= "serverless"
                                            }),
                                            var.default-labels)
                                        }"
}

resource "google_cloud_run_v2_service" "cloud-run-service" {
    project		    = "${var.project}"
    name            = "${local.cloud-run-service-name}"
    location        = "${var.region}"
    labels          = "${local.cloud-run-service-labels}"
    ingress         = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
    depends_on      = [ google_project_service.cloud-run-service ]
    
    template {
        service_account = google_service_account.cloud-run-service-service-account.email
        timeout         = "3s"

        containers {
            name = "${local.cloud-run-service-name}-container"
            image = "${local.cloud-run-image-location}"
            ports {
                name            = "http1"
                container_port  = "80"
            }

            startup_probe{
                initial_delay_seconds   = 0
                timeout_seconds         = 1
                period_seconds          = 10
                failure_threshold       = 3
                http_get {
                    path    = "/"
                    port    = 80
                }
            }

            liveness_probe{
                initial_delay_seconds   = 0
                timeout_seconds         = 1
                period_seconds          = 10
                failure_threshold       = 3
                http_get {
                    path    = "/"
                    port    = 80
                }
            }

        }

        scaling {
            min_instance_count  = 1
            max_instance_count  = 3
        }

    }

}

output "cloud-run-service-uri" {
	value		= "${google_cloud_run_v2_service.cloud-run-service.uri}"
	description	= "The main URI in which this Service is serving traffic."
	sensitive	= "false"
}

output "cloud-run-service-latest-ready-revision" {
	value		= "${google_cloud_run_v2_service.cloud-run-service.latest_ready_revision}"
	description	= "Name of the latest revision that is serving traffic. See comments in reconciling for additional information on reconciliation process in Cloud Run."
	sensitive	= "false"
}

output "cloud-run-service-latest-created-revision" {
	value		= "${google_cloud_run_v2_service.cloud-run-service.latest_created_revision}"
	description	= "Name of the last created revision. See comments in reconciling for additional information on reconciliation process in Cloud Run."
	sensitive	= "false"
}

output "cloud-run-service-traffic-statuses" {
	value		= "${google_cloud_run_v2_service.cloud-run-service.traffic_statuses}"
	description	= "Detailed status information for corresponding traffic targets. See comments in reconciling for additional information on reconciliation process in Cloud Run. Structure is documented below."
	sensitive	= "false"
}
