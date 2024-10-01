# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Private DNS Zones.
DESCRIPTION: The following components will be options in this deployment
            * Private DNS Zones
AUTHOR/S: jrspinella
*/

module "mod_default_pdz" {
  source     = "azurenoops/overlays-private-dns-zone/azurerm"
  version    = "1.0.2"
  depends_on = [module.mod_dns_rg]

  for_each = toset(concat(local.if_default_private_dns_zones_enabled, var.private_dns_zones))

  # Resource Group
  location                = module.mod_azregions.location_cli
  use_location_short_name = var.use_location_short_name # Use the short location name in the resource group name
  deploy_environment      = var.deploy_environment
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = "dns"

  private_dns_zone_name        = each.key
  existing_resource_group_name = module.mod_dns_rg[0].resource_group_name
  private_dns_zone_vnets_ids = [
    module.hub_vnet.vnet_resource.id,
  ]
  add_tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}

/* module "mod_default_pdz" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.4.0"
  depends_on = [module.mod_dns_rg]

  for_each = toset(concat(local.if_default_private_dns_zones_enabled, var.private_dns_zones))

  // Globals
  location            = module.mod_azregions.location_cli
  resource_group_name = module.mod_dns_rg[0].resource_group_name

  // Creatre new RG
  resource_group_creation_enabled = false

  //
  private_link_private_dns_zones = each.key

  // Virutal Netowrk Links
  virtual_network_resource_ids_to_link_to = {
    "vnet1_${each.key}" = {
      vnet_resource_id = module.hub_vnet.vnet_resource.id
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
} */

