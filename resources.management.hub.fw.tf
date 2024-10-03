# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy Azure Firewall in the hub vnet
DESCRIPTION: The following components will be options in this deployment
              * Firewall
AUTHOR/S: jrspinella
*/

#---------------------------------------------------------
# Firewall Subnet Creation or selection
#----------------------------------------------------------
resource "azurerm_subnet" "firewall_client_snet" {
  count                                         = var.enable_firewall ? 1 : 0
  name                                          = "AzureFirewallSubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = module.hub_vnet.vnet_resource.name
  address_prefixes                              = var.firewall_subnet_address_prefix
  service_endpoints                             = var.firewall_snet_service_endpoints
  private_endpoint_network_policies             = var.firewall_snet_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.firewall_snet_private_link_service_network_policies_enabled
}

#---------------------------------------------------------
# Firewall Management Subnet Creation
#----------------------------------------------------------
resource "azurerm_subnet" "firewall_management_snet" {
  count                                         = (var.enable_firewall && var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null) ? 1 : 0
  name                                          = "AzureFirewallManagementSubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = module.hub_vnet.vnet_resource.name
  address_prefixes                              = var.firewall_management_snet_address_prefix
  service_endpoints                             = var.firewall_management_snet_service_endpoints
  private_endpoint_network_policies             = var.firewall_management_snet_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.firewall_management_snet_private_link_service_network_policies_enabled
}

#------------------------------------------
# Public IP resources for Azure Firewall
#------------------------------------------
resource "azurerm_public_ip_prefix" "firewall_pref" {
  count               = var.enable_firewall ? 1 : 0
  name                = lower(format("%s-pip-prefix", local.hub_firewall_name))
  resource_group_name = local.resource_group_name
  location            = local.location
  prefix_length       = 30
  tags                = merge({ "ResourceName" = lower(format("%s-pip-prefix", local.hub_firewall_name)) }, local.default_tags, var.add_tags, )
}

module "hub_firewall_client_pip" {
  source  = "azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_firewall_client_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.firewall_pip_allocation_method
  sku                 = var.firewall_pip_sku
  zones               = var.firewall_zones != null ? var.firewall_zones : null
  public_ip_prefix_id = azurerm_public_ip_prefix.firewall_pref[0].id
  tags                = var.add_tags

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", local.hub_firewall_client_pip_name, var.lock_level)
    kind = var.lock_level
  } : null

  // FW PIP Diagnostic Settings
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = format("sendToLogAnalytics_%s_fwpip", var.workload_name)
      workspace_resource_id          = var.log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry
}

module "hub_firewall_management_pip" {
  source  = "azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  count               = var.enable_firewall && var.enable_forced_tunneling ? 1 : 0
  name                = local.hub_firewall_mgt_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.firewall_pip_allocation_method
  sku                 = var.firewall_pip_sku
  zones               = var.firewall_zones != null ? var.firewall_zones : null
  public_ip_prefix_id = azurerm_public_ip_prefix.firewall_pref[0].id
  tags                = var.add_tags

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", local.hub_firewall_mgt_pip_name, var.lock_level)
    kind = var.lock_level
  } : null

  // FW PIP Diagnostic Settings
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = format("sendToLogAnalytics_%s_fwmgtpip", var.workload_name)
      workspace_resource_id          = var.log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry
}

#-----------------
# Azure Firewall
#-----------------
/* resource "azurerm_firewall" "fw" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_firewall_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = module.hub_firewall_policy[0].resource.id
  threat_intel_mode   = var.firewall_threat_intelligence_mode
  zones               = var.firewall_zones
  tags                = merge({ "ResourceName" = format("%s", local.hub_firewall_name) }, local.default_tags, var.add_tags, )

  ip_configuration {
    name                 = lower(format("%s-ipconfig", local.hub_firewall_name))
    subnet_id            = azurerm_subnet.firewall_client_snet[0].id
    public_ip_address_id = module.hub_firewall_client_pip[0].public_ip_id
  }

  dynamic "management_ip_configuration" {
    for_each = var.enable_forced_tunneling ? [1] : []
    content {
      name                 = lower(format("%s-forced-tunnel-ipconfig", local.hub_firewall_name))
      subnet_id            = azurerm_subnet.firewall_management_snet[0].id
      public_ip_address_id = module.hub_firewall_management_pip[0].public_ip_id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.firewall_virtual_hub != null ? [var.firewall_virtual_hub] : []
    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
} */

module "hub_fw" {
  source  = "azure/avm-res-network-azurefirewall/azurerm"
  version = "0.2.2"
  count   = var.enable_firewall ? 1 : 0

  # Resource Group
  name                = local.hub_firewall_name
  resource_group_name = local.resource_group_name
  location            = local.location
  firewall_sku_name   = var.firewall_sku_name
  firewall_sku_tier   = var.firewall_sku_tier
  firewall_policy_id  = module.hub_firewall_policy[0].resource.id
  firewall_zones      = var.firewall_zones != null ? var.firewall_zones : null

  # Firewall Subnet
  firewall_ip_configuration = [
    {
      name                 = lower("${local.hub_firewall_name}-ipconfig")
      subnet_id            = azurerm_subnet.firewall_client_snet[0].id
      public_ip_address_id = module.hub_firewall_client_pip[0].public_ip_id
    }
  ]

  # Management IP Configuration
  firewall_management_ip_configuration = var.enable_forced_tunneling ? {
    name                 = lower("${local.hub_firewall_name}-forced-tunnel-ipconfig")
    subnet_id            = azurerm_subnet.firewall_management_snet[0].id
    public_ip_address_id = module.hub_firewall_management_pip[0].public_ip_id
  } : {}

  # Virtual Hub
  firewall_virtual_hub = var.firewall_virtual_hub != null ? var.firewall_virtual_hub : null

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", local.hub_firewall_name, var.lock_level)
    kind = var.lock_level
  } : null

  // Bastion Diagnostic Settings
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = format("sendToLogAnalytics_%s_fw", var.workload_name)
      workspace_resource_id          = var.log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }

  tags = merge({ "ResourceName" = format("%s", local.hub_firewall_name) }, local.default_tags, var.add_tags, )
}
