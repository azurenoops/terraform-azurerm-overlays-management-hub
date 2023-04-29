
#----------------------------------------------------------------
# Azure Role Assignment for Service Principal - current user
#-----------------------------------------------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "peering" {
  scope                = azurerm_virtual_network.hub_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "dns" {
  scope                = azurerm_private_dns_zone.pdz[0].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}