
#----------------------------------------
# Vault Core Private DNS Zone - Default is "true"
#----------------------------------------
resource "azurerm_private_dns_zone" "vault_core_pdz" {
  count               = var.enable_vault_core_private_dns_zone ? 1 : 0
  name                = var.environment == "public" ? "privatelink.vaultcore.azure.net" : "privatelink.blob.core.usgovcloudapi.net"
  resource_group_name = local.resource_group_name
  tags                = merge({ "ResourceName" = format("%s", lower(var.environment == "public" ? "privatelink.vaultcore.azure.net" : "privatelink.blob.core.usgovcloudapi.net")) }, local.default_tags, var.add_tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "dzvlink" {
  count                 = var.enable_vault_core_private_dns_zone ? 1 : 0
  name                  = lower("${var.private_dns_zone_name}-link")
  resource_group_name   = local.resource_group_name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  private_dns_zone_name = azurerm_private_dns_zone.vault_core_pdz[0].name
  tags                  = merge({ "ResourceName" = format("%s", lower("${var.environment == "public" ? "privatelink.vaultcore.azure.net" : "privatelink.blob.core.usgovcloudapi.net"}-link")) }, local.default_tags, var.add_tags, )
}

resource "azurerm_role_assignment" "dns" {
  scope                = azurerm_private_dns_zone.vault_core_pdz[0].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
