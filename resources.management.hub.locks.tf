# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Vnet Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "vnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.hub_vnet_name}-${var.lock_level}-lock"
  scope      = azurerm_virtual_network.hub_vnet.id
  lock_level = var.lock_level
  notes      = "Virtual Network '${local.hub_vnet_name}' is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# Subnet Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "subnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.hub_snet_name}-${var.lock_level}-lock"
  scope      = azurerm_subnet.default_snet.*.id
  lock_level = var.lock_level
  notes      = "Subnet '${local.hub_snet_name}' is locked with '${var.lock_level}' level."
}

resource "azurerm_management_lock" "fw_client_subnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "FW Client Subnet-${var.lock_level}-lock"
  scope      = azurerm_subnet.firewall_client_snet.0.id
  lock_level = var.lock_level
  notes      = "FW Client Subnet is locked with '${var.lock_level}' level."
}

resource "azurerm_management_lock" "fw_mgt_subnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "FW Management Subnet-${var.lock_level}-lock"
  scope      = azurerm_subnet.firewall_management_snet.0.id
  lock_level = var.lock_level
  notes      = "FW Management Subnet is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# Storage Account Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "sa_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.hub_sa_name}-${var.lock_level}-lock"
  scope      = azurerm_storage_account.storeacc.id
  lock_level = var.lock_level
  notes      = "Storage Account '${local.hub_sa_name}' is locked with '${var.lock_level}' level."
}

