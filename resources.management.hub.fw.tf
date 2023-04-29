# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a firewall in the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Firewall              
AUTHOR/S: jspinella
*/

#---------------------------------------------------------
# Firewall Subnet Creation or selection
#----------------------------------------------------------
resource "azurerm_subnet" "fw_client_snet" {
  count                                         = var.enable_firewall ? 1 : 0
  name                                          = "AzureFirewallSubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.fw_client_snet_address_prefix
  service_endpoints                             = var.fw_client_snet_service_endpoints
  private_endpoint_network_policies_enabled     = var.fw_client_snet_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.fw_client_snet_private_link_service_network_policies_enabled
}

#---------------------------------------------------------
# Firewall Managemnet Subnet Creation
#----------------------------------------------------------
resource "azurerm_subnet" "fw_management_snet" {
  count                                         = (var.enable_forced_tunneling && var.fw_management_snet_address_prefix != null) ? 1 : 0
  name                                          = "AzureFirewallManagementSubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.fw_management_snet_address_prefix
  service_endpoints                             = var.fw_management_snet_service_endpoints
  private_endpoint_network_policies_enabled     = var.fw_management_snet_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.fw_management_snet_private_link_service_network_policies_enabled
}

#------------------------------------------
# Public IP resources for Azure Firewall
#------------------------------------------
resource "azurerm_public_ip_prefix" "fw-pref" {
  count               = var.enable_firewall ? 1 : 0
  name                = lower("${local.hub_fw_name}-prefix")
  resource_group_name = local.resource_group_name
  location            = local.location
  prefix_length       = 30
  tags                = merge({ "ResourceName" = lower("${local.hub_fw_name}-prefix") }, var.tags, )
}

resource "azurerm_public_ip" "firewall_client_pip" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_fw_client_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.fw_pip_allocation_method
  sku                 = var.fw_pip_sku
  tags                = var.tags
}

resource "azurerm_public_ip" "firewall_management_pip" {
  count               = var.enable_forced_tunneling ? 1 : 0
  name                = local.hub_fw_mgt_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.fw_pip_allocation_method
  sku                 = var.fw_pip_sku
  tags                = var.tags
}

#-----------------
# Azure Firewall 
#-----------------
resource "azurerm_firewall" "fw" {
  count               = var.enable_firewall ? 1 : 0
  name                = local.hub_fw_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.firewall_config.sku_name
  sku_tier            = var.firewall_config.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.firewallpolicy.id
  dns_servers         = var.firewall_config.dns_servers
  private_ip_ranges   = var.firewall_config.private_ip_ranges
  threat_intel_mode   = lookup(var.firewall_config, "threat_intel_mode", "Alert")
  zones               = var.firewall_config.zones
  tags                = merge({ "ResourceName" = format("%s", local.hub_fw_name) }, var.tags, )

  ip_configuration {
    name                 = lower("${local.hub_fw_name}-ipconfig")
    subnet_id            = azurerm_subnet.fw_client_snet.0.id
    public_ip_address_id = azurerm_public_ip.firewall_client_pip.0.id
  }

  dynamic "management_ip_configuration" {
    for_each = var.enable_forced_tunneling ? [1] : []
    content {
      name                 = lower("${local.hub_fw_name}-forced-tunnel")
      subnet_id            = azurerm_subnet.fw_management_snet.0.id
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



