resource "azurerm_search_service" "ai_search" {
  name                = "${terraform.workspace}-azureaisearch_name"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku                 = "standard"
  partition_count     = 1
  replica_count       = 1
identity {
    type         = "SystemAssigned"
  }

  local_authentication_enabled = true
}

