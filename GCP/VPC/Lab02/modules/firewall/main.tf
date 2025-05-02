resource "google_compute_firewall" "allow-internal" {
  name    = var.name
  network = var.network

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["10.0.0.0/8"]
  direction     = "INGRESS"
}
