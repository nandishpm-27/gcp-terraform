provider "google" {
    credentials = file("gcp-account.json")
    project     = "gcp-terrafform"
    region      = "europe-west4"
    zone        = "europe-west4-a"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}