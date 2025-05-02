resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_network_security_group" "nsgs" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                = "${each.value.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

locals {
  flattened_rules = flatten([
    for subnet in var.subnets : [
      for rule in subnet.nsg_rules : {
        key         = "${subnet.name}-${rule.name}"
        subnet_name = subnet.name
        rule        = rule
      }
    ]
  ])

  subnet_rules = { for rule in local.flattened_rules : rule.key => rule }
}


resource "azurerm_network_security_rule" "rules" {
  for_each = local.subnet_rules

  name                        = each.value.rule.name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[each.value.subnet_name].name
}


resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}
