###### AV Groups ######

resource "azurerm_availability_set" "data_avset" {
  name                         = "${var.dns_name}avset"
  location                     = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

