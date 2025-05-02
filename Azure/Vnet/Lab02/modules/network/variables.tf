variable "vnet_name" {}
variable "address_space" {}
variable "location" {}
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    nsg_rules      = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}
variable "resource_group_name" {
  description = "Nombre del grupo de recursos donde se despliegan los recursos de red"
  type        = string
}
