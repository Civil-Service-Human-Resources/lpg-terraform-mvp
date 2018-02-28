###### cosmos mongodb ######

resource "azurerm_cosmosdb_account" "cosmos_mongodb" {
  name                = ""
  location            = ""
  resource_group_name = ""
  offer_type          = "Standard"

  consistency_policy {
    consistency_level = "Strong"
  }

  failover_policy {
    location = "UK West"
    priority = 1
  }

}