
#----------------------------------------
# Private DNS Zone - Default is "true"
#----------------------------------------
resource "azurerm_private_dns_zone" "pdz" {
  count               = var.private_dns_zone_name != null ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = local.resource_group_name
  tags                = merge({ "ResourceName" = format("%s", lower(var.private_dns_zone_name)) }, var.tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "dzvlink" {
  count                 = var.private_dns_zone_name != null ? 1 : 0
  name                  = lower("${var.private_dns_zone_name}-link")
  resource_group_name   = local.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  private_dns_zone_name = azurerm_private_dns_zone.pdz[0].name
  tags                  = merge({ "ResourceName" = format("%s", lower("${var.private_dns_zone_name}-link")) }, var.tags, )
}