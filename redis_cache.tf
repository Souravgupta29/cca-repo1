
resource "azurerm_redis_cache" "example" {
  name                = "${terraform.workspace}-redis_cache_name"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name  # You need to define this elsewhere
  capacity            = 0
  family              = "C"
  sku_name = "Standard"
  minimum_tls_version = "1.2"
}
