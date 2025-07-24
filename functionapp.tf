

# Existing App Service Plan (Linux)
data "azurerm_service_plan" "existing_asp" {
  name                = "ai-analytics-dev-eus-001-ai-services-sp"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}



variable "storageaccounttype" {
  default = "Standard_LRS"
}



# 2. Storage Account
resource "azurerm_storage_account" "func_storage" {
  name                     = lower("${terraform.workspace}${var.func_stracc_name}") # must be lowercase
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  account_tier             = split("_", var.storageaccounttype)[0]
  account_replication_type = split("_", var.storageaccounttype)[1]
  account_kind = "StorageV2"
  min_tls_version          = "TLS1_2"
}

# 3. Application Insights
resource "azurerm_application_insights" "func_appinsight" {
  name                = "${terraform.workspace}-${var.func_appinsight_name}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  application_type    = "web"
}

# 4. Azure Function App
resource "azurerm_linux_function_app" "function" {
  name                       = "${terraform.workspace}-${var.funcapp_name}"
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.existing_rg.name
  service_plan_id            = data.azurerm_service_plan.existing_asp.id
  storage_account_name       = azurerm_storage_account.func_storage.name
  storage_account_access_key = azurerm_storage_account.func_storage.primary_access_key
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }
  site_config {
    always_on        = true
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    AzureWebJobsDashboard                    = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.func_storage.name};AccountKey=${azurerm_storage_account.func_storage.primary_access_key}"
    AzureWebJobsStorage                      = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.func_storage.name};AccountKey=${azurerm_storage_account.func_storage.primary_access_key}"
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.func_storage.name};AccountKey=${azurerm_storage_account.func_storage.primary_access_key}"
    WEBSITE_CONTENTSHARE                     = lower(var.funcapp_name)
    FUNCTIONS_EXTENSION_VERSION              = "~4"
    APPINSIGHTS_INSTRUMENTATIONKEY           = azurerm_application_insights.func_appinsight.instrumentation_key
    FUNCTIONS_WORKER_RUNTIME                 = "python"
    WEBSITE_NODE_DEFAULT_VERSION             = "~14"
  }

  https_only = true
}
