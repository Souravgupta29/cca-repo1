resource "azurerm_cognitive_account" "content_safety" {
  name                = "${terraform.workspace}-${var.contentsafety_name}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku_name = "S0"
  kind                = "ContentSafety"
  custom_subdomain_name = "${terraform.workspace}-contentsafety_name"
  public_network_access_enabled = true  

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }
}


resource "azurerm_role_assignment" "uami_cognitive_services_contributor" {
  scope              = azurerm_cognitive_account.content_safety.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68" # Cognitive Services Contributor
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "uami_cognitive_services_openai_user" {
  scope              = azurerm_cognitive_account.content_safety.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/5e0bd9bd-7b93-4f28-af87-19fc36ad61bd" # Cognitive Services OpenAI User
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "uami_cognitive_services_openai_contributor" {
  scope              = azurerm_cognitive_account.content_safety.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/a001fd3d-188f-4b5d-821b-7da978bf7442" # Cognitive Services OpenAI Contributor
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "uami_cognitive_services_user" {
  scope              = azurerm_cognitive_account.content_safety.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/a97b65f3-24c7-4388-baec-2e87135dc908" # Cognitive Services User
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}
