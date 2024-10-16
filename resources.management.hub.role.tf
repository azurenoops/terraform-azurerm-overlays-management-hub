# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: This module deploys the role assignments for the hub network
DESCRIPTION: The following components will be options in this deployment
              * Azure Role Assignment for Service Principal - current user
              * Azure Role Assignment for Private DNS Zone Contributor
              * Azure Role Assignment for Storage Blob Data Contributor
AUTHOR/S: jrspinella
*/

#----------------------------------------------------------------
# Azure Role Assignment for Service Principal - current user
#-----------------------------------------------------------------
resource "azurerm_role_assignment" "default_dns" {
  for_each             = toset(concat(local.if_default_private_dns_zones_enabled, var.private_dns_zones))
  scope                = module.mod_default_pdz[each.key].private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
