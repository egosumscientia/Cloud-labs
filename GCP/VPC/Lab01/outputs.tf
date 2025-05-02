output "instance_ip" {
  description = "Dirección IP pública de la VM"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
