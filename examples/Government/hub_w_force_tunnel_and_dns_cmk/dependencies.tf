# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#----------------------------------------------
# Log Analytics Workspace
#----------------------------------------------

resource "azurerm_resource_group" "laws_rg" {
  name     = "laws-rg-${var.default_location}-${var.org_name}"
  location = var.default_location
}

resource "azurerm_log_analytics_workspace" "laws" {
  name                = "laws-${var.default_location}-${var.org_name}"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.laws_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = "30"
}

resource "azurerm_key_vault" "kv" {
  name                = "examplekv"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.laws_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "Premium"

  purge_protection_enabled = true
}

# Create a User Assigned Identity for the Windows Jumpbox for Azure Disk Encryption
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  location            = var.default_location
  resource_group_name = azurerm_resource_group.laws_rg.name
  name                = "kv_usi"
}