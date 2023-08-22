# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a route table in the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Route Table
                * Route Table Association
                * Route     
AUTHOR/S: jspinella
*/

resource "azurerm_route_table" "routetable" {
  name                          = local.hub_rt_name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = merge({ "ResourceName" = "route-network-outbound" }, local.default_tags, var.add_tags, )
}

resource "azurerm_subnet_route_table_association" "rtassoc" {
  for_each       = var.hub_subnets
  subnet_id      = azurerm_subnet.default_snet[each.key].id
  route_table_id = azurerm_route_table.routetable.id
}

resource "azurerm_route" "force_internet_tunneling" {
  name                   = lower("route-to-firewall-${local.hub_vnet_name}-${local.location}")
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_in_ip_address = azurerm_firewall.fw.0.ip_configuration.0.private_ip_address
  next_hop_type          = "VirtualAppliance"

  count = var.enable_forced_tunneling ? 1 : 0
}

# Encrypted Transport Route Table
resource "azurerm_route_table" "afw_routetable" {
  name                          = local.hub_afw_rt_name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  disable_bgp_route_propagation = false
  tags                          = merge({ "ResourceName" = "afw-route-network-outbound" }, local.default_tags, var.add_tags, )

  count = var.enable_encrypted_transport ? 1 : 0
}

resource "azurerm_subnet_route_table_association" "afw_rtassoc" {
  subnet_id      = azurerm_subnet.firewall_client_snet.id
  route_table_id = azurerm_route_table.afw_routetable.id

  count = var.enable_encrypted_transport ? 1 : 0
}

resource "azurerm_route" "route" {
  for_each               = var.route_table_routes
  name                   = lower("route-to-firewall-${each.value.route_name}-${local.location}")
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}

resource "azurerm_route" "route" {
  name                   = lower("route-to-firewall-${each.value.route_name}-${local.location}")
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.afw_routetable.name
  address_prefix         = var.encrypted_transport_address_prefix
  next_hop_type          = var.encrypted_transport_next_hop_type
  next_hop_in_ip_address = var.encrypted_transport_next_hop_in_ip_address
  
  count = var.enable_encrypted_transport ? 1 : 0
}
