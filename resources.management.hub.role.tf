
#----------------------------------------------------------------
# Azure Role Assignment for Service Principal - current user
#-----------------------------------------------------------------
resource "azurerm_role_assignment" "peering" {
  scope                = module.hub_vnet.vnet_resource.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "dns" {
  for_each             = toset(local.if_default_private_dns_zones_enabled)
  scope                = module.mod_pdz[each.key].private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "law_contributor" {
  for_each             = toset(local.if_default_private_dns_zones_enabled)
  scope                = module.mod_ops_logging.laws_resource_id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
