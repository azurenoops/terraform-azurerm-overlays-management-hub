# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "netwatch" {
  depends_on = [module.hub_vnet]
  name       = "NetworkWatcherRG"
}

data "azurerm_network_watcher" "nwatcher" {
  depends_on          = [module.hub_vnet]
  name                = "NetworkWatcher_${local.location}"
  resource_group_name = data.azurerm_resource_group.netwatch.name
}

data "azurerm_private_dns_zone" "blob" {
  depends_on          = [module.mod_default_pdz]
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.mod_dns_rg[0].resource_group_name
}
