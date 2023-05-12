# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an Azure Monitor Private Endpoints and Private DNS Zones
DESCRIPTION: The following components will be options in this deployment
            *  Private Endpoints            
AUTHOR/S: jspinella
*/

#######################################
### Private Endpoint Configuration  ###
#######################################

resource "azurerm_subnet" "pe_snet" {
  name                                          = "ampls-private-endpoints"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.ampls_subnet_address_prefix
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = true
}


module "mod_ampls_main_private_endpoint" {
  source = "./modules/private_endpoints"
  depends_on = [ module.mod_ops_logging.global_pls, module.mod_ampls_pdz.this ]

  org_name           = var.org_name
  environment        = var.environment
  deploy_environment = var.deploy_environment
  location           = local.location
  workload_name      = var.workload_name

  resource_group_name = local.resource_group_name
  subnet_id           = azurerm_subnet.pe_snet.id
  target_resource     = module.mod_ops_logging.0.laws_private_link_scope_id
  subresource_name    = "azuremonitor"

  use_existing_private_dns_zones = true
  private_dns_zones_ids        = [for s in module.mod_ampls_pdz : s.private_dns_zone_id]

}
