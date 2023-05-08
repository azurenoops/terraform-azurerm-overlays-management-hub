
#----------------------------------------
# Private DNS Zone
#----------------------------------------
resource "azurerm_private_dns_zone" "pdz" {
  for_each            = toset(var.private_dns_zones)
  name                = each.key
  resource_group_name = local.resource_group_name
  tags                = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "dzvlink" {
  for_each              = toset(var.private_dns_zones)
  name                  = lower("${azurerm_virtual_network.hub_vnet.name}-${azurerm_private_dns_zone.pdz[each.key].name}-link")
  resource_group_name   = local.resource_group_name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  private_dns_zone_name = azurerm_private_dns_zone.pdz[each.key].name
  tags                  = merge({ "ResourceName" = format("%s", lower("${each.key}-link")) }, local.default_tags, var.add_tags, )
}
