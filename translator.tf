resource "azurerm_cognitive_account" "translator" {
  name                        = "${terraform.workspace}-${var.translator_name}"   
  location                    = var.location
  resource_group_name         = data.azurerm_resource_group.existing_rg.name
  kind                        = "TextTranslation"
  custom_subdomain_name       = "${terraform.workspace}-${var.translator_name}"
  sku_name = "S1"
  public_network_access_enabled = true

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
}

  network_acls {
    default_action = "Allow"
    ip_rules       = []
  }
}


resource "azurerm_role_assignment" "translator_role_assignment" {
  scope                = azurerm_cognitive_account.translator.id
  role_definition_id   = "/providers/Microsoft.Authorization/roleDefinitions/25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68" # Cognitive Services Contributor
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
  principal_type       = "ServicePrincipal"
}
