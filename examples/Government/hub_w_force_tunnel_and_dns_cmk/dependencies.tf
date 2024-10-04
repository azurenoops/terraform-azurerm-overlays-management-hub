# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#----------------------------------------------
# Log Analytics Workspace
#----------------------------------------------
data "azurerm_client_config" "current" {}

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
  name                = "kv-${var.default_location}-${var.org_name}"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.laws_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Delete"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set",
      "SetSAS",
      "GetSAS",
      "DeleteSAS",
      "Update",
      "RegenerateKey"
    ]
  }
}

resource "azurerm_key_vault_key" "kv_key" {
  name         = "cmk-for-storage-account"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]
}
