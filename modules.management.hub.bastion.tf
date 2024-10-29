# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy Azure Bastion Host
DESCRIPTION: The following components will be options in this deployment
            * Bastion Host with Jumpboxes
AUTHOR/S: jrspinella
*/
#####################################
### Bastion Host Configuration    ###
#####################################

resource "random_string" "str" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    domain_name_label = var.azure_bastion_service_name
  }
}

#-----------------------------------------------------------------------
# Subnets Creation for Azure Bastion Service - at least /27 or larger.
#-----------------------------------------------------------------------
module "abs_snet" {
  source     = "azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version    = "0.4.2"
  depends_on = [module.hub_vnet]
  count      = (var.enable_bastion_host && var.azure_bastion_subnet_address_prefix != null) ? 1 : 0

  # Resource Name
  name = "AzureBastionSubnet"

  # Virtual Networks
  virtual_network = {
    resource_id = module.hub_vnet.resource_id
  }

  # Subnet Information
  address_prefixes = var.azure_bastion_subnet_address_prefix
  # Applicable to the subnets which used for Private link endpoints or services
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
}

#---------------------------------------------
# Public IP for Azure Bastion Service
#---------------------------------------------
module "hub_bastion_pip" {
  source  = "azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.2"

  count               = var.enable_bastion_host ? 1 : 0
  name                = local.bastion_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.azure_bastion_public_ip_allocation_method
  sku                 = var.azure_bastion_public_ip_sku
  zones               = var.firewall_zones != null ? var.firewall_zones : null
  domain_name_label   = var.domain_name_label != null ? var.domain_name_label : format("%s%s", lower(replace(local.bastion_pip_name, "/[[:^alnum:]]/", "")), random_string.str.result)

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", local.bastion_pip_name, var.lock_level)
    kind = var.lock_level
  } : null

  // Bastion PIP Diagnostic Settings
  diagnostic_settings = var.existing_log_analytics_workspace_resource_id != null ? {
    sendToLogAnalytics = {
      name                           = format("sendToLogAnalytics_%s_bastionpip", var.workload_name)
      workspace_resource_id          = var.existing_log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated"
    }
  } : null

  # telemtry
  enable_telemetry = var.enable_telemetry

  # Tags
  tags = merge({ "ResourceName" = local.bastion_pip_name }, local.default_tags, var.add_tags, )
}

#---------------------------------------------
# Azure Bastion Service host
#---------------------------------------------
module "hub_bastion_host" {
  source  = "azure/avm-res-network-bastionhost/azurerm"
  version = "0.3.0"

  count = var.enable_bastion_host ? 1 : 0

  # Resource Group
  name                = local.bastion_name
  location            = local.location
  resource_group_name = local.resource_group_name

  # Bastion Host
  copy_paste_enabled = var.enable_copy_paste
  file_copy_enabled  = var.azure_bastion_host_sku == "Standard" ? var.enable_file_copy : null
  sku                = var.azure_bastion_host_sku
  ip_configuration = {
    name                 = "${lower(local.bastion_name)}-ipconfig"
    subnet_id            = module.abs_snet[0].resource_id
    public_ip_address_id = module.hub_bastion_pip[0].public_ip_id
  }
  ip_connect_enabled     = var.enable_ip_connect
  scale_units            = var.azure_bastion_host_sku == "Standard" ? var.scale_units : 2
  shareable_link_enabled = var.azure_bastion_host_sku == "Standard" ? var.enable_shareable_link : null
  tunneling_enabled      = var.azure_bastion_host_sku == "Standard" ? var.enable_tunneling : null

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", local.bastion_name, var.lock_level)
    kind = var.lock_level
  } : null

  // Bastion Diagnostic Settings
  diagnostic_settings = var.existing_log_analytics_workspace_resource_id != null ? {
    sendToLogAnalytics = {
      name                           = format("sendToLogAnalytics_%s_bastion", var.workload_name)
      workspace_resource_id          = var.existing_log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated"
    }
  } : null

  # telemtry
  enable_telemetry = var.enable_telemetry

  # tags
  tags = merge({ "ResourceName" = format("%s", local.bastion_name) }, local.default_tags, var.add_tags, )
}
