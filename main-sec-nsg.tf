###### NSG Settings ######

resource "azurerm_network_security_group" "public_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-public"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "http_public" {
  name                        = "http"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.public_sg.name}"
}

resource "azurerm_network_security_rule" "https_public" {
  name                        = "https"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.public_sg.name}"
}

resource "azurerm_network_security_rule" "ssh_to_public_from_bastion" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.11.0/24"
  destination_address_prefix  = "10.0.10.0/24"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.public_sg.name}"
}

resource "azurerm_network_security_group" "bastion_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-bastion"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "ssh_from_outside_to_bastion" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bastion_sg.name}"
}

resource "azurerm_network_security_group" "admin_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-admin"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "http_admin" {
  name                        = "http"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.admin_sg.name}"
}

resource "azurerm_network_security_rule" "https_admin" {
  name                        = "https"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.admin_sg.name}"
}

resource "azurerm_network_security_rule" "ssh_to_admin_from_bastion" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.11.0/24"
  destination_address_prefix  = "10.0.10.0/24"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.admin_sg.name}"
}

resource "azurerm_network_security_group" "app_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-app"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "ssh_to_app_from_bastion" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.11.0/24"
  destination_address_prefix  = "10.0.13.0/24"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.app_sg.name}"
}

resource "azurerm_network_security_group" "dgraph_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-dgraph"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "ssh_to_dgraph_from_bastion" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.11.0/24"
  destination_address_prefix  = "10.0.14.0/24"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.dgraph_sg.name}"
}

resource "azurerm_network_security_rule" "https_from_admin" {
  name                        = "https"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.12.0/24"
  destination_address_prefix  = "10.0.14.0/24"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.dgraph_sg.name}"
}

resource "azurerm_network_security_group" "redis_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-dgraph"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_group" "gateways_sg" {
  name                = "${var.rg_prefix}-${terraform.workspace}-gateways"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}