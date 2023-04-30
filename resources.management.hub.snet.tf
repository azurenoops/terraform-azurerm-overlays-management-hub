# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a subnet in the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Subnets      
AUTHOR/S: jspinella
*/

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/servie network policies, service endpoints and Deligation.
#--------------------------------------------------------------------------------------------------------

resource "azurerm_subnet" "gw_snet" {
  count                                         = var.gateway_subnet_address_prefix != null ? 1 : 0
  name                                          = "GatewaySubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.gateway_subnet_address_prefix
  service_endpoints                             = var.gateway_service_endpoints
  private_endpoint_network_policies_enabled     = var.gateway_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.gateway_private_link_service_network_policies_enabled
}

resource "azurerm_subnet" "default_snet" {
  for_each             = var.subnets
  name                 = lower(format("${var.org_name}-${module.mod_azregions.location_cli}-%s-snet", each.value.name))
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = each.value.subnet_address_prefix
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # Applicable to the subnets which used for Private link endpoints or services 
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}
