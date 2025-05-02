provider "azurerm" {
  features {}
  subscription_id = "5f55b5a1-09ef-4b87-b02d-30e1a8347b3d"
}

resource "azurerm_resource_group" "lab_rg" {
  name     = "rg-vnet-lab"
  location = "East US"
}

resource "azurerm_virtual_network" "lab_vnet" {
  name                = "vnet-lab"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
}

resource "azurerm_subnet" "lab_subnet" {
  name                 = "subnet-lab"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "lab_ip" {
  name                = "lab-ip"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  sku                 = "Standard"  # Standard SKU requires static allocation
  allocation_method   = "Static"    # Fixing the issue here
}

resource "azurerm_network_interface" "lab_nic" {
  name                = "nic-lab"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab_ip.id
  }
}

# Cambia la imagen si quieres Windows ("Win2019Datacenter")
variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

resource "azurerm_windows_virtual_machine" "lab_vm" {
  name                  = "vm-lab"
  resource_group_name   = azurerm_resource_group.lab_rg.name
  location              = azurerm_resource_group.lab_rg.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.lab_nic.id]
  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "lab_nsg" {
  name                = "nsg-lab"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "lab_nic_nsg" {
  network_interface_id      = azurerm_network_interface.lab_nic.id
  network_security_group_id = azurerm_network_security_group.lab_nsg.id
}
