# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to configure diagnostic settings for VNet, NSG, PIP, Bastion and Firewall
DESCRIPTION: The following components will be options in this deployment
            * Diagnostic settings for VNet
            * Diagnostic settings for NSG
            * Diagnostic settings for Firewall
            * Diagnostic settings for Firewall PIP
            * Diagnostic settings for Bastion
AUTHOR/S: jrspinella
*/

##############################################
### Azure Monitor diagnostics Configuration ##
##############################################

module "mod_vnet_diagnostic_settings" {
  source  = "azurenoops/overlays-diagnostic-settings/azurerm"
  version = "1.5.0"

  count = var.existing_log_analytics_workspace_resource_id ? 1 : 0

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("sendToLogAnalytics_%s_vnet", var.workload_name)


  resource_id           = module.hub_vnet.resource_id
  logs_destinations_ids = [var.existing_log_analytics_workspace_resource_id, module.hub_st.resource.id]
}

module "mod_nsg_diagnostic_settings" {
  source  = "azurenoops/overlays-diagnostic-settings/azurerm"
  version = "1.5.0"

  for_each = toset(var.existing_log_analytics_workspace_resource_id ? [var.hub_subnets] : [])

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("sendToLogAnalytics_%s_nsg", var.workload_name)

  resource_id           = module.nsg[each.key].resource_id
  logs_destinations_ids = [var.existing_log_analytics_workspace_resource_id, module.hub_st.resource.id]
}