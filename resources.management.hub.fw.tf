# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a firewall in the Hub Network based on the Azure Mission Landing Zone conceptual architecture
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
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.firewall_subnet_address_prefix
  service_endpoints                             = var.firewall_snet_service_endpoints
  private_endpoint_network_policies_enabled     = var.firewall_snet_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.firewall_snet_private_link_service_network_policies_enabled
}

#---------------------------------------------------------
# Firewall Management Subnet Creation
#----------------------------------------------------------
resource "azurerm_subnet" "firewall_management_snet" {
  count                                         = (var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null) ? 1 : 0
  name                                          = "AzureFirewallManagementSubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.firewall_management_snet_address_prefix
  service_endpoints                             = var.firewall_management_snet_service_endpoints
  private_endpoint_network_policies_enabled     = var.firewall_management_snet_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.firewall_management_snet_private_link_service_network_policies_enabled
}

#------------------------------------------
# Public IP resources for Azure Firewall
#------------------------------------------
resource "azurerm_public_ip_prefix" "firewall_pref" {
  count               = var.enable_firewall ? 1 : 0
  name                = lower("${local.hub_firewall_name}-prefix")
  resource_group_name = local.resource_group_name
  location            = local.location
  prefix_length       = 30
  tags                = merge({ "ResourceName" = lower("${local.hub_firewall_name}-prefix") }, local.default_tags, var.add_tags, )
}

resource "azurerm_public_ip" "firewall_client_pip" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_firewall_client_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.firewall_pip_allocation_method
  sku                 = var.firewall_pip_sku
  zones               = var.firewall_zones != null ? var.firewall_zones : null
  public_ip_prefix_id = azurerm_public_ip_prefix.firewall_pref.0.id
  tags                = var.add_tags
}

resource "azurerm_public_ip" "firewall_management_pip" {
  count               = var.enable_forced_tunneling ? 1 : 0
  name                = local.hub_firewall_mgt_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.firewall_pip_allocation_method
  sku                 = var.firewall_pip_sku
  zones               = var.firewall_zones != null ? var.firewall_zones : null
  public_ip_prefix_id = azurerm_public_ip_prefix.firewall_pref.0.id
  tags                = var.add_tags
}

#-----------------
# Azure Firewall 
#-----------------
resource "azurerm_firewall" "fw" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_firewall_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.firewallpolicy.id
  threat_intel_mode   = var.firewall_threat_intelligence_mode
  zones               = var.firewall_zones != null ? var.firewall_zones : null
  tags                = merge({ "ResourceName" = format("%s", local.hub_firewall_name) }, local.default_tags, var.add_tags, )

  ip_configuration {
    name                 = lower("${local.hub_firewall_name}-ipconfig")
    subnet_id            = azurerm_subnet.firewall_client_snet.0.id
    public_ip_address_id = azurerm_public_ip.firewall_client_pip.0.id
  }

  dynamic "management_ip_configuration" {
    for_each = var.enable_forced_tunneling ? [1] : []
    content {
      name                 = lower("${local.hub_firewall_name}-forced-tunnel-ipconfig")
      subnet_id            = azurerm_subnet.firewall_management_snet.0.id
      public_ip_address_id = azurerm_public_ip.firewall_management_pip[0].id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.virtual_hub != null ? [var.virtual_hub] : []
    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
}



