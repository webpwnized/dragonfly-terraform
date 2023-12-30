
resource "google_compute_firewall" "allow-egress-web-from-application-server" {
	project		= "${google_compute_network.gcp_vpc_network.project}"
	name		= "allow-egress-web-from-application-server"
	network 	= "${google_compute_network.gcp_vpc_network.name}"
	description	= "Allow HTTP, HTTPS traffic leaving the ${google_compute_network.gcp_vpc_network.name} network"
	direction	= "EGRESS"
	disabled	= "false"
	priority	= 1000

	allow {
		protocol	= "tcp"
		ports		= ["${var.http-port}","${var.https-port}"]
	}

	target_tags		= ["application-server"]
	
	log_config {
		metadata	= "INCLUDE_ALL_METADATA"
	}
}
