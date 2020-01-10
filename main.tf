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
  credentials_file = "auth-file-123456678.json"
  region           = "${var.region}"
  zone             = "${var.region}-a"
  project          = "${var.project}"
  domain           = "buildingbridge.com"
  dns_zone         = "buildingbridge"
  public_ip        = "1.2.3.4"
  certificate      = "https://www.googleapis.com/compute/v1/project/terraform-test/global/sslCertificates/tfe"
  subnet           = "tfe-subnet"
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
