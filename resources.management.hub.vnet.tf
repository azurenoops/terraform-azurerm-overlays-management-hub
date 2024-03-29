# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Hub Network Virtual Network
              * Ddos Protection Plan
              * Network Watcher
AUTHOR/S: jrspinella
*/

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------
module "hub_vnet" {
  source  = "azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.1"

  # Resource Group
  name                = local.hub_vnet_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # Virtual Network DNS Servers
  virtual_network_dns_servers = {
    dns_servers = var.dns_servers
  }

  # Virtual Network Address Space
  virtual_network_address_space = var.virtual_network_address_space

  # Ddos protection plan - Default is "false"
  virtual_network_ddos_protection_plan = var.create_ddos_plan ? {
    enable = true
    id     = module.hub_vnet_ddos.0.resource.id
  } : null

  # Diagnostic Settings
  diagnostic_settings = {
    vnet_dia = {
      name                           = format("%s-diag", local.hub_vnet_name)
      storage_account_resource_id    = module.hub_st.id
      workspace_resource_id          = module.mod_ops_logging.laws_resource_id
      log_analytics_destination_type = "AzureDiagnostics"
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.hub_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  # telemtry
  enable_telemetry = var.disable_telemetry

  tags = merge({ "ResourceName" = format("%s", local.hub_vnet_name) }, local.default_tags, var.add_tags, )
}

#--------------------------------------------
# Ddos protection plan - Default is "false"
#--------------------------------------------
module "hub_vnet_ddos" {
  source              = "azure/avm-res-network-ddosprotectionplan/azurerm"
  version             = "~> 0.1"
  count               = var.create_ddos_plan ? 1 : 0
  name                = local.ddos_plan_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.ddos_plan_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

   # telemtry
  enable_telemetry = var.disable_telemetry

  tags = merge({ "ResourceName" = format("%s", local.ddos_plan_name) }, local.default_tags, var.add_tags, )
}

