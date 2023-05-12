# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an Private DNS Zones and Azure Monitor Private DNS Zones
DESCRIPTION: The following components will be options in this deployment
            * Bastion Host with Jumpboxes    
AUTHOR/S: jspinella
*/

#----------------------------------------
# Private DNS Zone
#----------------------------------------
module "mod_pdz" {
  source                = "./modules/private_dns_zone"
  for_each              = toset(var.private_dns_zones)
  private_dns_zone_name = each.key
  resource_group_name   = local.resource_group_name
  private_dns_zone_vnets_ids = [
    azurerm_virtual_network.hub_vnet.id
  ]
  add_tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}

#----------------------------------------
# AMPLS Private DNS Zone
#----------------------------------------
module "mod_ampls_pdz" {
  source                = "./modules/private_dns_zone"
  for_each              = toset(local.ample_dns_zones)
  private_dns_zone_name = each.key
  resource_group_name   = local.resource_group_name
  private_dns_zone_vnets_ids = [
    azurerm_virtual_network.hub_vnet.id
  ]
  add_tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}
