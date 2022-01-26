##### Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}"
 region      = "${var.region}"
}


#### Create VPC
resource "google_compute_network" "vpc" {
 name                    = "dunnhumby-vpc"
 auto_create_subnetworks = "false"
}

###Create Subnet


resource "google_compute_subnetwork" "subnet" {
 name          = "dunnhumby-subnet"
 ip_cidr_range = "${var.subnet_cidr}"
 network       = "dunnhumby-vpc"
 depends_on    = ["google_compute_network.vpc"]
 region      = "${var.region}"
}

##### VPC firewall configuration: Doing additional because will do ssh to check docker image part####
resource "google_compute_firewall" "firewall" {
  name    = "dunnhumby-firewall"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}


