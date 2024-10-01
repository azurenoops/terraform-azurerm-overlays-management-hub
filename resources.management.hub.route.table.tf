# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a route table and associated routes
DESCRIPTION: The following components will be options in this deployment
              * Route Table
                * Route Table Association
                * Route
AUTHOR/S: jrspinella
*/

resource "azurerm_route_table" "routetable" {
  name                          = local.hub_rt_name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  bgp_route_propagation_enabled = var.disable_bgp_route_propagation
  tags                          = merge({ "ResourceName" = "route-network-outbound" }, local.default_tags, var.add_tags, )
}

resource "azurerm_subnet_route_table_association" "rtassoc" {
  for_each       = var.hub_subnets
  subnet_id      = azurerm_subnet.default_snet[each.key].id
  route_table_id = azurerm_route_table.routetable.id
}

resource "azurerm_route" "force_internet_tunneling" {
  name                   = lower(format("route-to-firewall-%s", local.hub_vnet_name))
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_in_ip_address = module.hub_fw.resource[0].ip_configuration[0].private_ip_address
  next_hop_type          = "VirtualAppliance"

  count = var.enable_firewall && var.enable_forced_tunneling ? 1 : 0
}

resource "azurerm_route" "route" {
  for_each               = var.route_table_routes
  name                   = lower(format("route-to-firewall-%s", each.value.route_name))
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}

# Encrypted Transport Route Table
resource "azurerm_route_table" "afw_routetable" {
  name                          = local.hub_afw_rt_name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  bgp_route_propagation_enabled = false
  tags                          = merge({ "ResourceName" = "afw-subnet-route-network-outbound" }, local.default_tags, var.add_tags, )

  count = var.enable_encrypted_transport ? 1 : 0
}

resource "azurerm_subnet_route_table_association" "afw_rtassoc" {
  subnet_id      = azurerm_subnet.firewall_client_snet[0].id
  route_table_id = azurerm_route_table.afw_routetable[0].id

  count = var.enable_encrypted_transport ? 1 : 0
}

resource "azurerm_route" "afw_route" {
  name                   = lower(format("route-to-afw-subnet-%s",local.location))
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.afw_routetable[0].name
  address_prefix         = var.encrypted_transport_address_prefix
  next_hop_type          = var.encrypted_transport_next_hop_type
  next_hop_in_ip_address = var.encrypted_transport_next_hop_in_ip_address

  count = var.enable_encrypted_transport ? 1 : 0
}
