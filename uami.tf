

resource "azurerm_user_assigned_identity" "uami" {
  name                = "${terraform.workspace}-uami_name"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

output "identity_id" {
  value       = azurerm_user_assigned_identity.uami.id
}

output "identity_principal_id" {
  value       = azurerm_user_assigned_identity.uami.principal_id
}

output "identity_client_id" {
  value       = azurerm_user_assigned_identity.uami.client_id
}
