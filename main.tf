variable "region" {
  default = "us-west1-b"
}

variable "project" {
  default = "rising-goal-259700"
  }

provider "google-beta" {
  region  = "${var.region}"
  project = "${var.project}"
}

module "bb-host" {
  source           = "buildingbridge/terraform-google-hosts"
  version          = "0.1.1"
  credentials_file = "GoogleCloudTesting-97dd385312f1.json"
  region           = "${var.region}"
  zone             = "${var.region}-a"
  project          = "${var.project}"
  domain           = "buildingbridge.com"
  dns_zone         = "buildingbridge"
  public_ip        = "1.2.3.4"
  subnet           = "bb-host-subnet"
}

output "bb-host" {
  value = {
    application_endpoint         = "${module.bb-host.application_endpoint}"
    installer_dashboard_password = "${module.bb-host.installer_dashboard_password}"
    installer_dashboard__url     = "${module.bb-host.installer_dashboard_url}"
    primary_public_ip            = "${module.bb-host.primary_public_ip}"
    encryption_password          = "${module.bb-host.encryption_password}"
  }
}
  
  
resource "google_compute_instance" "vm_instance" {
  name         = "bb-host-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "buildingbridge/bb-default-host-image"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "${google_compute_network.vpc_network.self_link}"
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "bb-host-network"
  auto_create_subnetworks = "true"
}

