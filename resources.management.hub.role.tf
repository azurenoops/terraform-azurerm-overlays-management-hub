
#----------------------------------------------------------------
# Azure Role Assignment for Service Principal - current user
#-----------------------------------------------------------------
resource "azurerm_role_assignment" "peering" {
  scope                = azurerm_virtual_network.hub_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "dns" {
  for_each             = toset(var.private_dns_zones)
  scope                = module.mod_pdz[each.key].private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}