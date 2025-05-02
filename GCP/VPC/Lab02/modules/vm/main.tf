resource "google_compute_instance" "vm_instance" {
  name         = var.name
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {}
  }

  tags = ["ssh", "internal-test"]
}
