# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Private DNS Zones.
DESCRIPTION: The following components will be options in this deployment
            * Private DNS Zones
AUTHOR/S: jrspinella
*/

module "mod_pdz" {
  source     = "azurenoops/overlays-private-dns-zone/azurerm"
  version    = "~> 1.0"
  depends_on = [module.mod_dns_rg]

  for_each = toset(local.if_default_private_dns_zones_enabled)

  # Resource Group
  location                = module.mod_azregions.location_cli
  use_location_short_name = var.use_location_short_name # Use the short location name in the resource group name
  deploy_environment      = var.deploy_environment
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = "dns"

  private_dns_zone_name        = each.key
  existing_resource_group_name = module.mod_dns_rg.0.resource_group_name
  private_dns_zone_vnets_ids = [
    module.hub_vnet.vnet_resource.id,
  ]
  add_tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}

