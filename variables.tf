//########################################################################
//	These variables must be set
//	Rename this file to variables.tf when finished
//########################################################################

variable "terraform-credentials-file" {
	type 		= string
	default 	= "/home/jeremy/.creds/terraform-service-account-key.json"
	description	= "The GCP service account that Terraform will use to authenticate to the project. Create a service account in GCP for Terraform to use. See https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform"
}

variable "project" {
	type 		= string
	default 	= "concise-display-321523"
	description	= "The GCP project in which the assets will be built"
}

variable "default-labels" { 
	type = map(string)
	default = {
		owner: "jeremy",
		environment: "testnet",
		application: "dragonfly"
	}
	description	= "The labels that will be applied to the IaaS assets"
}

//########################################################################
//	The default value of these varaibles may be used or changed.
//	The default value is probably fine.
//########################################################################

variable "application-name" {
	type = string
	default = "dragonfly"
}

variable "region" {
	type = string
	default = "us-central1"
}

variable "zone" {
	type = string
	default = "us-central1-a"
}

variable "cloud-run-service-subnet-ip-address-range" {
	type = string
	default = "10.0.1.0/28"
}

variable "http-port" {
	type = string
	default = "80"
}

variable "https-port" {
	type = string
	default = "443"
}
