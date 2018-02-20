###### redis ######

variable "redis_name" {
  description = "Name of Application that these VMs will be used running"
  default     = "redis"
}

resource "azurerm_redis_cache" "redis_cache" {
  name                = "${var.rg_prefix}-${terraform.workspace}-${var.redis_name}"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  capacity            = 1
  family              = "P"
  sku_name            = "Premium"
  enable_non_ssl_port = true
  shard_count         = 1

  redis_configuration {
    maxclients         = 7500
    maxmemory_reserved = 2
    maxmemory_delta    = 2
    maxmemory_policy   = "allkeys-lru"
  }
}