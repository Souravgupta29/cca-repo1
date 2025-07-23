
variable "webAppPlan_Sku" {
  default     = "P1v2"
}



resource "azurerm_service_plan" "webappasp" {
  name                = "${terraform.workspace}-webappasp_name"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  os_type  = "Windows"
  sku_name = "P1v2"
}


output "webappaspid" {
  value = azurerm_service_plan.webappasp.id
}


resource "azurerm_windows_web_app" "webApplication" {
  name = "${terraform.workspace}-${var.webapp_name}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  service_plan_id = azurerm_service_plan.webappasp.id
   identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
  }
  site_config {
    application_stack {
      current_stack = "dotnetcore"
      dotnet_core_version = "v4.0"
    }
  }
  https_only = true
}
