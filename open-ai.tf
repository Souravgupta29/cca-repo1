variable "sku" {
  default     = "S0"
}

resource "azurerm_cognitive_account" "azure_openai" {
  name                = "${terraform.workspace}-${var.azureopenai_name}"  
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku_name            = var.sku
  kind                = "OpenAI"
  custom_subdomain_name = "${terraform.workspace}-azureopenai_name"
 identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }

}

resource "azurerm_cognitive_deployment" "openaigpt4o" {
  name                   = var.gpt4o_name
  cognitive_account_id   = azurerm_cognitive_account.azure_openai.id
  rai_policy_name        = "Microsoft.DefaultV2"
  version_upgrade_option = "OnceCurrentVersionExpired"

  model {
    format  = "OpenAI"
    name = "gpt-4o"
  }

  scale {
    type     = "GlobalStandard"
    capacity = 8
  }
}

resource "azurerm_cognitive_deployment" "textembeddingada002" {
  name = "text-embedding-ada-002"
  cognitive_account_id   = azurerm_cognitive_account.azure_openai.id
  rai_policy_name        = "Microsoft.DefaultV2"
  version_upgrade_option = "OnceCurrentVersionExpired"

  model {
    format  = "OpenAI"
    name = "text-embedding-ada-002"
    version = "2"
  }

  scale {
    type     = "Standard"
    capacity = 150
  }

  depends_on = [
    azurerm_cognitive_deployment.openaigpt4o
  ]
}

resource "azurerm_role_assignment" "uami_openai_user" {
  scope              = azurerm_cognitive_account.azure_openai.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/5e0bd9bd-7b93-4f28-af87-19fc36ad61bd" # Cognitive Services OpenAI User
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "uami_contributor" {
  scope              = azurerm_cognitive_account.azure_openai.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68" # Cognitive Services Contributor
  principal_id       = azurerm_user_assigned_identity.uami.principal_id
  principal_type     = "ServicePrincipal"
}

