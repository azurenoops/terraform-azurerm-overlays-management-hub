# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: This module deploys a Network Security Group (NSG) to the specified hub subnets
DESCRIPTION: The following components will be options in this deployment
              * Network Watcher
AUTHOR/S: jrspinella
*/

module "nsg" {
  source  = "azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  for_each = var.hub_subnets

  name                = var.hub_nsg_custom_name != null ? format("%s_%s", var.hub_nsg_custom_name, each.key) : data.azurenoopsutils_resource_name.nsg[each.key].result
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = lower("nsg_${each.key}") }, local.default_tags, var.add_tags, )

  security_rules =  each.value.nsg_subnet_rules 
}

resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  for_each                  = var.hub_subnets
  subnet_id                 = module.default_snet[each.key].resource_id
  network_security_group_id = module.nsg[each.key].resource_id
}



