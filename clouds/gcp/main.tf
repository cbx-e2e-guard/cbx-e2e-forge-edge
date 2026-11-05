# A GCP root (`cloud: gcp` in .cbx-guard.yml, CB-1171 / REV-130). The e2e org connects no GCP
# project, so the review plans it offline (the google recipe in apps/api/src/review/offline-env.ts)
# and resolves it from the plan only. Its firewall already admits SSH from 0.0.0.0/0 to an app VM
# with an external IP on the default branch: every review of this root keeps that as a pre-existing
# finding, which opens the note that says the verdict came from the plan only.
# Its resources are named `app`, not `bastion`: a bastion is an expected opening, which the review
# grades clean, and a clean pre-existing finding opens no note.
#
# The google pin is the version the worker image mirrors (infra/docker/terraform/providers.tf), so
# init installs it from disk. realworld-scenarios.test.ts fails when the two drift.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.8.1"
    }
  }
}

variable "project" {
  type    = string
  default = "cbx-offline-plan"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "app" {
  name                    = "vpc-orders-prod"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app" {
  name          = "snet-app"
  region        = var.region
  network       = google_compute_network.app.id
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_firewall" "app_ssh" {
  name          = "allow-app-ssh"
  network       = google_compute_network.app.name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["app"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "app" {
  name         = "vm-app"
  machine_type = "e2-small"
  zone         = "${var.region}-b"
  tags         = ["app"]

  labels = {
    environment = "prod"
    service     = "orders"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app.id

    access_config {}
  }
}
