# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to create subnets in the hub vnet
DESCRIPTION: The following components will be options in this deployment
              * Subnets
AUTHOR/S: jrspinella
*/

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/service network policies, service endpoints and Delegation.
#--------------------------------------------------------------------------------------------------------

module "gw_snet" {
  source  = "azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.6.0"
  depends_on = [ module.hub_vnet ]
  count   = var.gateway_subnet_address_prefix != null ? 1 : 0

  # Resource Name
  name = "GatewaySubnet"

  # Virtual Networks
  virtual_network = {
    resource_id = module.hub_vnet.resource_id
  }

  # Subnet Information
  address_prefixes                              = var.gateway_subnet_address_prefix
  service_endpoints                             = var.gateway_service_endpoints
  private_endpoint_network_policies             = var.gateway_private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.gateway_private_link_service_network_policies_enabled
}

module "default_snet" {
  source   = "azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version  = "0.6.0"
  depends_on = [ module.hub_vnet ]
  for_each = var.hub_subnets

  # Resource Name
  name = var.hub_snet_custom_name != null ? format("%s-%s", var.hub_snet_custom_name, each.key) : data.azurenoopsutils_resource_name.snet[each.key].result

  # Virtual Networks
  virtual_network = {
    resource_id = module.hub_vnet.resource_id
  }

  # Subnet Information
  address_prefixes  = each.value.address_prefixes
  service_endpoints = lookup(each.value, "service_endpoints", [])
  # Applicable to the subnets which used for Private link endpoints or services
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)
}
