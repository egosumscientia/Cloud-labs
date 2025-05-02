output "vm_name" {
  value = azurerm_windows_virtual_machine.vm.name
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.vm.id
}
