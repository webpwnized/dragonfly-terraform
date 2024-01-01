
locals {
	gke-cluster-network-name		= "${google_compute_network.gcp_vpc_network.name}"
	gke-cluster-subnetwork-name		= "${google_compute_subnetwork.application-subnetwork.name}"
	gke-cluster-name 	= "${var.application-name}-gke-cluster"
	gke-cluster-description	= "A GKE Cluster to run Docker containers"

	gke-node-image-type 		= "COS_CONTAINERD"
	gke-node-disk-size-gb		= 25
	gke-node-initial-node-count	= 1
	gke-node-min-node-count		= 1
	gke-node-max-node-count		= 3
}

resource "google_container_cluster" "gke_cluster" {
	project		= "${var.project}"
	location	= "${var.zone}"
	network		= "${local.gke-cluster-network-name}"
	subnetwork	= "${local.gke-cluster-subnetwork-name}"
	name		= "${local.gke-cluster-name}"

	# We can't create a cluster with no node pool defined, but we want to only use
	# separately managed node pools. So we create the smallest possible default
  	# node pool and immediately delete it.
	remove_default_node_pool	= true
	initial_node_count			= 1
	addons_config {
		horizontal_pod_autoscaling {
			disabled	= false
		}
		http_load_balancing {
			disabled	= false
		}
		network_policy_config {
			disabled	= false
		}
	}
	confidential_nodes {
		enabled		= true
	}
}

resource "google_container_node_pool" "gke_cluster_nodes" {
	project			= "${google_container_cluster.gke_cluster.project}"
	name			= "${google_container_cluster.gke_cluster.name}-node-pool"
	cluster			= "${google_container_cluster.gke_cluster.name}"
	location		= "${google_container_cluster.gke_cluster.location}"
	initial_node_count	= local.gke-node-initial-node-count
	autoscaling {
		min_node_count	= local.gke-node-min-node-count
		max_node_count	= local.gke-node-max-node-count		
	}
	management {
		auto_repair	= true
		auto_upgrade	= true
	}
	node_config {
		image_type 		= "${local.gke-node-image-type}"
		machine_type	= "${var.vm-machine-type}"
		disk_size_gb	= local.gke-node-disk-size-gb
		disk_type 		= "${var.vm-boot-disk-type}"
		tags         	= ["gke-node"]
		shielded_instance_config {
			enable_secure_boot		= true
			enable_integrity_monitoring	= true
		}
		metadata = {
    		disable-legacy-endpoints = "true"
    	}
	}
}

output "gke-cluster-endpoint-ip" {
	value 		= google_container_cluster.gke_cluster.endpoint
	description	= "The IP address of this clusters Kubernetes master"
	sensitive	= false
}

output "gke-cluster-master-version" {
	value 		= google_container_cluster.gke_cluster.master_version
	description	= "The current version of the clusters Kubernetes master"
	sensitive	= false
}

output "gke-cluster-services-ip-range" {
	value 		= google_container_cluster.gke_cluster.services_ipv4_cidr
	description	= "The IP address range of the Kubernetes services in this cluster"
	sensitive	= false
}


output "gke-cluster-name" {
	value 		= google_container_cluster.gke_cluster.name
	description	= "The GKE cluster name"
	sensitive	= false
}


