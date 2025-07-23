
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.65"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.12"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {

}

variable "location" {}
variable "multiService_name" {}
variable "azureaisearch_name" {}
variable "azureopenai_name" {}
variable "contentsafety_name" {}
variable "gpt4o_name" {}
variable "sqlserver_name" {}
variable "sqlDB1_name" {}
variable "sqlDB2_name" {}
variable "administrator_login" {}
variable "administrator_login_password" {
  sensitive   = true
}
variable "storageaccount_name" {}
variable "translator_name" {}
variable "webapp_name" {}
variable "webappasp_name" {}
variable "func_stracc_name" {}
variable "func_appinsight_name" {}
variable "funcapp_name" {}
variable "uami_name" {}
variable "redis_cache_name" {}


data "azurerm_resource_group" "existing_rg" {
  name = "rg-cca-tf-testing"
}