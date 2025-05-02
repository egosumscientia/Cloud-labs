provider "azurerm" {
  features {}
  subscription_id = "foo"
}

resource "azurerm_resource_group" "rg" {
  name     = "lab-rg"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "lab-vnet"
  address_space       = "10.0.0.0/16"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnets             = var.subnets
}


module "vm1" {
  source              = "./modules/vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_name             = "vm-subnet1"
  subnet_id           = module.network.subnet_ids["subnet1"]
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "vm2" {
  source              = "./modules/vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_name             = "vm-subnet2"
  subnet_id           = module.network.subnet_ids["subnet2"]
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}
