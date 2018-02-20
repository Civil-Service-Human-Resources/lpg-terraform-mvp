###### Resource Group / VNETs / Stor ######

resource "azurerm_resource_group" "rg" {
  name     = "${terraform.workspace}_${var.resource_group}"
  location = "${lookup(var.zone, terraform.workspace)}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${terraform.workspace}-${var.virtual_network_name}"
  location            = "${lookup(var.zone, terraform.workspace)}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet_public" {
  name                      = "${var.rg_prefix}-subnet-public"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "10.0.10.0/24"
  network_security_group_id = "${azurerm_network_security_group.public_sg.id}"
}

resource "azurerm_subnet" "subnet_bastion" {
  name                      = "${var.rg_prefix}-subnet-bastion"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "10.0.11.0/24"
  network_security_group_id = "${azurerm_network_security_group.bastion_sg.id}"
}

resource "azurerm_subnet" "subnet_admin" {
  name                      = "${var.rg_prefix}-subnet-admin"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "10.0.12.0/24"
  network_security_group_id = "${azurerm_network_security_group.admin_sg.id}"
}

resource "azurerm_subnet" "subnet_xapiworker" {
  name                      = "${var.rg_prefix}-subnet-xapiworker"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "10.0.13.0/24"
  network_security_group_id = "${azurerm_network_security_group.xapiworker_sg.id}"
}

resource "azurerm_subnet" "subnet_dgraph" {
  name                      = "${var.rg_prefix}-subnet-dgraph"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "10.0.14.0/24"
  network_security_group_id = "${azurerm_network_security_group.dgraph_sg.id}"
}

resource "azurerm_subnet" "subnet_redis" {
  name                      = "${var.rg_prefix}-subnet-redis"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "10.0.15.0/24"
  network_security_group_id = "${azurerm_network_security_group.redis_sg.id}"
}


resource "azurerm_storage_account" "stor" {
  name                     = "${terraform.workspace}_${var.dns_name}_stor"
  location                 = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.storage_replication_type}"
}