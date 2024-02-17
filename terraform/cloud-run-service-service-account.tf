locals {
	cloud-run-service-service-account-id	= "cloudrunserviceaccount"
}

resource "google_service_account" "cloud-run-service-service-account" {
	project			= "${var.project}"
	account_id		= "${local.cloud-run-service-service-account-id}"
	display_name	= "${local.cloud-run-service-service-account-id}"
	description		= "${local.cloud-run-service-service-account-id}"
	disabled		= "false"
}

output "cloud-run-service-service-account-email" {
	value		= "${google_service_account.cloud-run-service-service-account.email}"
	description	= "The e-mail address of the service account. This value should be referenced from any google_iam_policy data sources that would grant the service account privileges."
	sensitive	= "false"
}

output "cloud-run-service-service-account-unique-id" {
	value		= "${google_service_account.cloud-run-service-service-account.unique_id}"
	description	= "The unique id of the service account"
	sensitive	= "false"
}

output "cloud-run-service-service-account-member" {
	value		= "${google_service_account.cloud-run-service-service-account.member}"
	description	= "The Identity of the service account in the form serviceAccount:{email}. This value is often used to refer to the service account in order to grant IAM permissions."
	sensitive	= "false"
}

