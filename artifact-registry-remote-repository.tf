# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository

locals {
	// These default values should work without changes
	
	//Make sure these are set for this machine
	repository-name 			            = "${var.application-name}-remote-repository"
    dockerhub-repository-name               = "dragonfly"
    dockerhub-repository-container-name     = "www"
	repository-description		            = "Remote container repository for project ${var.application-name} acting as a proxy for for the Dockerhub containers at https://hub.docker.com/repository/docker/webpwnized/dragonfly/"
	repository-labels 			= "${merge(
                                    tomap({ 
                                        "purpose"	            = "container-repository",
                                        "asset-type"	        = "serverless",
                                        "remote-repository"     = "Dockerhub"
                                        "remote-repository-url" =   "https://hub.docker.com/repository/docker/webpwnized/dragonfly/"
                                    }),
                                    var.default-labels)
                                }"
}

resource "google_artifact_registry_repository" "remote-dockerhub-repository" {
    provider        = google-beta
    project		    = "${var.project}"
    location        = "${var.region}"
    description     = "${local.repository-description}"
    repository_id   = "${local.dockerhub-repository-name}"
    format          = "DOCKER"
    mode            = "REMOTE_REPOSITORY" 

    cleanup_policies {
        id                      = "Keep-Latest-Version"
        action                  = "KEEP"
        most_recent_versions {
            package_name_prefixes = ["${local.dockerhub-repository-container-name}"]
            keep_count            = 1
        }
    }

    remote_repository_config {
        description = "${local.repository-description}"
        docker_repository {
            public_repository = "DOCKER_HUB"
        }
    }
}