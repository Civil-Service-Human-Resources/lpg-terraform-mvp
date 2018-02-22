###### Application Gateways ######

variable "public_gw_name" {
  description = "Name of Application that these VMs will be used running"
  default     = "public-gw"
}

resource "azurerm_public_ip" "public_pip" {
  name                         = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
}

# Create an application gateway
resource "azurerm_application_gateway" "public" {
  name                = "${azurerm_resource_group.rg.name}-${var.public_gw_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"

  sku {
    name           = "WAF_Medium"
    tier           = "WAF"
    capacity       = 2
  }

  gateway_ip_configuration {
      name         = "${azurerm_resource_group.rg.name}-${var.public_gw_name}"
      subnet_id    = "${azurerm_virtual_network.vnet.id}/subnets/${azurerm_subnet.subnet_gateways.name}"
  }

  frontend_port {
      name         = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-feport"
      port         = 80
  }

  frontend_ip_configuration {
      name         = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-feip"
      public_ip_address_id = "${azurerm_public_ip.public_pip.id}"
  }

  backend_address_pool {
      name = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-beap"
      ip_address_list = ["10.0.10.4","10.0.10.5"]
  }

  backend_http_settings {
      name                  = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-be-htst"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
     request_timeout        = 1
  }

  http_listener {
        name                                  = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-httplstn"
        frontend_ip_configuration_name        = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-feip"
        frontend_port_name                    = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-feport"
        protocol                              = "Http"
  }

  request_routing_rule {
          name                       = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-rqrt"
          rule_type                  = "Basic"
          http_listener_name         = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-httplstn"
          backend_address_pool_name  = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-beap"
          backend_http_settings_name = "${azurerm_resource_group.rg.name}-${var.public_gw_name}-be-htst"
  }
}