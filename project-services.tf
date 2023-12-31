
resource "google_project_service" "osconfig-service" {
	project						= "${var.project}"
	service						= "osconfig.googleapis.com"
	disable_on_destroy			= "true"
	disable_dependent_services	= "true"
}

resource "google_project_service" "containeranalysis-service" {
	project						= "${var.project}"
	service						= "containeranalysis.googleapis.com"
	disable_on_destroy			= "true"
	disable_dependent_services	= "true"
}

resource "google_project_service" "container-service" {
	project						= "${var.project}"
	service						= "container.googleapis.com"
	disable_on_destroy			= "true"
	disable_dependent_services	= "true"
}

resource "google_project_service" "cloud-run-service" {
	project						= "${var.project}"
	service						= "run.googleapis.com"
	disable_on_destroy			= "true"
	disable_dependent_services	= "true"
}
