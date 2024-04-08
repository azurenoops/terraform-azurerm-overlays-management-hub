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
