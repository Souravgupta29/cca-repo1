

resource "azurerm_storage_account" "storageaccount" {
  name                     = lower("${terraform.workspace}${var.storageaccount_name}")   //var.storageaccount_name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    Environment = terraform.workspace
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "blob_data_reader" {
  scope              = azurerm_storage_account.storageaccount.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope              = azurerm_storage_account.storageaccount.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe"
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

output "storage_account_connection_string" {
  value     = azurerm_storage_account.storageaccount.primary_connection_string
  sensitive = true
}