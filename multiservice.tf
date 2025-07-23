resource "azurerm_cognitive_account" "cognitive_service" {
  name                = "${terraform.workspace}-multiService_name"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku_name            = var.sku
  kind                = "CognitiveServices"
  custom_subdomain_name = "${terraform.workspace}-multiService_name"
  
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }
}


resource "azurerm_role_assignment" "multiservice_uami_cognitive_services_contributor" {
  scope              = azurerm_cognitive_account.cognitive_service.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68"
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "multiservice_uami_cognitive_services_openai_user" {
  scope              = azurerm_cognitive_account.cognitive_service.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/5e0bd9bd-7b93-4f28-af87-19fc36ad61bd"
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "multiservice_uami_cognitive_services_user1" {
  scope              = azurerm_cognitive_account.cognitive_service.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/a97b65f3-24c7-4388-baec-2e87135dc908"
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

# resource "azurerm_role_assignment" "multiservice_azureaisearch_cognitive_services_user2" {
#   scope              = azurerm_cognitive_account.cognitive_service.id
#   role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/a97b65f3-24c7-4388-baec-2e87135dc908"
#   principal_id       = azurerm_search_service.ai_search.identity[0].principal_id
#   principal_type     = "ServicePrincipal"
# }

resource "azurerm_role_assignment" "multiservice_azureopenai_cognitive_services_user3" {
  scope              = azurerm_cognitive_account.cognitive_service.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/a97b65f3-24c7-4388-baec-2e87135dc908"
  principal_id       = azurerm_cognitive_account.azure_openai.identity[0].principal_id
  principal_type     = "ServicePrincipal"
}
