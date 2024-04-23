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

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("%s-vnet", var.workload_name)


  resource_id           = module.hub_vnet.vnet_resource.id
  logs_destinations_ids = [var.log_analytics_workspace_resource_id, module.hub_st.id]
}

module "mod_nsg_diagnostic_settings" {
  source  = "azurenoops/overlays-diagnostic-settings/azurerm"
  version = "1.5.0"

  for_each = var.hub_subnets

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("%s-nsg", var.workload_name)

  resource_id           = azurerm_network_security_group.nsg[each.key].id
  logs_destinations_ids = [var.log_analytics_workspace_resource_id, module.hub_st.id]
}

module "mod_fw_diagnostic_settings" {
  source  = "azurenoops/overlays-diagnostic-settings/azurerm"
  version = "1.5.0"

  count = var.enable_firewall ? 1 : 0

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("%s-fw", var.workload_name)

  resource_id           = azurerm_firewall.fw[0].id
  logs_destinations_ids = [var.log_analytics_workspace_resource_id, module.hub_st.id]
}

module "mod_fw_pip_diagnostic_settings" {
  source  = "azurenoops/overlays-diagnostic-settings/azurerm"
  version = "1.5.0"

  count = var.enable_firewall ? 1 : 0

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("%s-fw-pip", var.workload_name)

  resource_id           = module.hub_firewall_client_pip[0].public_ip_id
  logs_destinations_ids = [var.log_analytics_workspace_resource_id, module.hub_st.id]
}

module "mod_bastion_diagnostic_settings" {
  source  = "azurenoops/overlays-diagnostic-settings/azurerm"
  version = "1.5.0"

  count = var.enable_bastion_host ? 1 : 0

  # Resource Group, location, VNet and Subnet details
  location           = var.location
  deploy_environment = var.deploy_environment
  environment        = var.environment
  org_name           = var.org_name
  workload_name      = format("%s-bas", var.workload_name)

  resource_id           = module.hub_bastion_host[0].bastion_resource.id
  logs_destinations_ids = [var.log_analytics_workspace_resource_id, module.hub_st.id]
}
