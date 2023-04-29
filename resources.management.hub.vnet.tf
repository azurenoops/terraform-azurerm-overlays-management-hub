# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Hub Network Virtual Network    
              * Ddos Protection Plan
              * Network Watcher         
AUTHOR/S: jspinella
*/

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------
resource "azurerm_virtual_network" "hub_vnet" {
  depends_on = [
    module.mod_hub_rg
  ]
  name                = local.hub_vnet_name
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = var.virtual_network_address_space
  dns_servers         = var.dns_servers
  tags                = merge({ "ResourceName" = format("%s", local.hub_vnet_name) }, var.tags, )

  dynamic "ddos_protection_plan" {
    for_each = local.if_ddos_enabled

    content {
      id     = azurerm_network_ddos_protection_plan.ddos[0].id
      enable = true
    }
  }
}

#--------------------------------------------
# Ddos protection plan - Default is "false"
#--------------------------------------------

resource "azurerm_network_ddos_protection_plan" "ddos" {
  count               = var.create_ddos_plan ? 1 : 0
  name                = var.ddos_plan_name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = format("%s", var.ddos_plan_name) }, var.tags, )
}

#-------------------------------------
# Network Watcher - Default is "true"
#-------------------------------------
resource "azurerm_resource_group" "nwatcher" {
  count    = var.create_network_watcher != false ? 1 : 0
  name     = "NetworkWatcherRG"
  location = local.location
  tags     = merge({ "ResourceName" = "NetworkWatcherRG" }, var.tags, )
}

resource "azurerm_network_watcher" "nwatcher" {
  count               = var.create_network_watcher != false ? 1 : 0
  name                = "NetworkWatcher_${var.location}"
  location            = local.location
  resource_group_name = azurerm_resource_group.nwatcher.0.name
  tags                = merge({ "ResourceName" = format("%s", "NetworkWatcher_${var.location}") }, var.tags, )
}
