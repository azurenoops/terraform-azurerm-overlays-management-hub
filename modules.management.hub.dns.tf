# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an Private DNS Zones and Azure Monitor Private DNS Zones
DESCRIPTION: The following components will be options in this deployment
            * Bastion Host with Jumpboxes    
AUTHOR/S: jrspinella
*/

#----------------------------------------
# Private DNS Zone
#----------------------------------------
module "mod_dns_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "~> 1.0.1"

  count = length(var.private_dns_zones) > 0 ? 1 : 0

  location                = module.mod_azregions.location_cli
  use_location_short_name = var.use_location_short_name # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = "dns-zones"
  custom_rg_name          = var.custom_hub_resource_group_name != null ? var.custom_hub_resource_group_name : null

  // Tags
  add_tags = merge(local.default_tags, var.add_tags, )
}

module "mod_pdz" {
  source     = "./modules/private_dns_zone"
  depends_on = [module.mod_dns_rg]

  for_each              = toset(var.private_dns_zones)
  private_dns_zone_name = each.key
  resource_group_name   = module.mod_dns_rg.resource_group_name
  private_dns_zone_vnets_ids = [
    azurerm_virtual_network.hub_vnet.id
  ]
  add_tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}

