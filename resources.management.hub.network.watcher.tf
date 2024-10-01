# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: This module deploys a Network Watcher flow log for each subnet and NSG in the hub vnet
DESCRIPTION: The following components will be options in this deployment
              * Network Watcher
AUTHOR/S: jrspinella
*/

resource "azurerm_network_watcher_flow_log" "nwflog" {
  for_each                  = var.hub_subnets
  name                      = lower(format("network-watcher-flow-log-%s-%s", var.org_name, each.value.name))
  network_watcher_name      = data.azurerm_network_watcher.nwatcher.name
  resource_group_name       = data.azurerm_resource_group.netwatch.name # Must provide Netwatcher resource Group
  network_security_group_id = module.nsg[each.key].id
  storage_account_id        = module.hub_st.id
  enabled                   = true
  version                   = 2
  retention_policy {
    enabled = true
    days    = 0
  }

  traffic_analytics {
    enabled               = var.enable_traffic_analytics
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = local.location
    workspace_resource_id = var.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
}

/* module "network_watcher_flow_log" {
  source                    = "Azure/azurerm-avm-res-network-networkwatcher/azurerm"
  version                   = "0.1.1"
  for_each                  = var.hub_subnets
  name                      = lower(format("network-watcher-flow-log-%s-%s", var.org_name, each.value.name))
  net
  network_watcher_name      = data.azurerm_network_watcher.nwatcher.name
  resource_group_name       = data.azurerm_resource_group.netwatch.name # Must provide Netwatcher resource Group
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = module.hub_st.id
} */
