# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Network Watcher Flog Logs for Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Network Watcher
AUTHOR/S: jrspinella
*/

#-----------------------------------------
# Network flow logs for subnet and NSG
#-----------------------------------------
resource "azurerm_network_watcher_flow_log" "nwflog" {
  for_each                  = var.hub_subnets
  name                      = lower("network-watcher-flow-log-${each.value.name}")
  network_watcher_name      = data.azurerm_network_watcher.nwatcher.name
  resource_group_name       = data.azurerm_resource_group.netwatch.name # Must provide Netwatcher resource Group
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = module.hub_st.id
  enabled                   = true
  version                   = 2
  retention_policy {
    enabled = true
    days    = 0
  }

  traffic_analytics {
    enabled               = var.enable_traffic_analytics
    workspace_id          = module.mod_ops_logging.laws_workspace_id
    workspace_region      = local.location
    workspace_resource_id = module.mod_ops_logging.laws_resource_id
    interval_in_minutes   = 10
  }
}
