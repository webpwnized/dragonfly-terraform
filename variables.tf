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

variable "ssh-public-key-file" {
	type 		= string
	default 	= "/home/jeremy/.ssh/gcp-ssh-key.pub"
	description	= "The SSH public key you will use to authenticate to the IaaS bastion host via GCP Identity Aware Proxy and the Docker Host using SSH"
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

variable "admin-office-ip-address-range" {
	type = list(string)
	default = ["104.0.151.118/32"]
	description	= "Your IP address. Terraform will set up firewall rules allowing access from this range."
}

variable "database-username-secret" {
	type 		= string
	default 	= "dragonfly-database-username"
	description	= "The name of the GCP secret that stores the database username the dragonfly application uses to authenticate to the Cloud SQL database. Because the value is sensitive, the value must be stored in GCP Secret Manager. See https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets"
}

variable "database-password-secret" {
	type 		= string
	default 	= "dragonfly-database-password"
	description	= "The name of the GCP secret that stores the database password the dragonfly application uses to authenticate to the Cloud SQL database. Because the value is sensitive, the value must be stored in GCP Secret Manager. See https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets"
}

//########################################################################
//	The default value of these varaibles may be used or changed.
//	The default value is probably fine.
//########################################################################

variable "application-name" {
	type = string
	default = "dragonfly"
}

variable "dragonfly-application-name" {
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

variable "bastion-host-subnet-ip-address-range" {
	type = string
	default = "10.0.0.0/28"
}

variable "cloud-run-service-subnet-ip-address-range" {
	type = string
	default = "10.0.1.0/28"
}

variable "gcp-iap-ip-address-range" {
	type = list(string)
	default = ["35.235.240.0/20"]
}

variable "gcp-health-check-ip-address-range" {
	type = list(string)
	default = ["130.211.0.0/22", "35.191.0.0/16"]
}

variable "ssh-port" {
	type = string
	default = "22"
}

variable "http-port" {
	type = string
	default = "80"
}

variable "https-port" {
	type = string
	default = "443"
}

variable "ntp-port" {
	type = string
	default = "123"
}

variable "dragonfly-http-port" {
	type = string
	default = "80"
}

variable "vm-machine-type" {
	type = string
	default = "e2-small"
}

variable "vm-boot-disk-type" {
	type = string
	default = "pd-standard"
}

variable "vm-metadata-startup-script" {
	type = string
	default = "#! /bin/bash\nsudo apt update\nsudo apt -y install google-osconfig-agent"
}

