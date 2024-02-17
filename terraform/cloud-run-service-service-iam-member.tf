# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam#google_cloud_run_v2_service_iam_member

resource "google_cloud_run_v2_service_iam_member" "cloud-run-iam-member" {
    project		= "${var.project}"
    location    = "${var.region}"
    name        = "${google_cloud_run_v2_service.cloud-run-service.name}"     
    member      = "allUsers"
    role        = "roles/run.invoker"
}