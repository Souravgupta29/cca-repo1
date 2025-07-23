
variable "sku_name" {
  default = "GP_Gen5_2"
}



resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sqlserver_name
  location                     = var.location
  resource_group_name          = data.azurerm_resource_group.existing_rg.name
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_mssql_database" "sqlDB1" {
  name                = "${terraform.workspace}-sqlDB1_name"
  server_id           = azurerm_mssql_server.sqlserver.id
  max_size_gb         = 500
  zone_redundant      = false
  storage_account_type = "Local"
  sku_name = "sku_name"
}

resource "azurerm_mssql_database" "sqlDB2" {
  name                = "${terraform.workspace}-sqlDB2_name"
  server_id           = azurerm_mssql_server.sqlserver.id
  max_size_gb         = 500
  zone_redundant      = false
  storage_account_type = "Local"
  sku_name = "sku_name"
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
