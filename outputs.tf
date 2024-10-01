# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, module.mod_scaffold_rg[*].resource_group_name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp[*].id, module.mod_scaffold_rg[*].resource_group_id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, module.mod_scaffold_rg[*].resource_group_location, [""]), 0)
}

# Vnet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.hub_vnet.vnet_resource.name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.hub_vnet.virtual_network_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = module.hub_vnet.vnet_resource.address_space
}

output "gateway_subnet_id" {
  description = "Name of gateway subnet id"
  value       = var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet[0].id : null
}

output "gateway_subnet_name" {
  description = "Name of gateway subnet"
  value       = var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet[0].name : null
}

output "firewall_client_subnet_id" {
  description = "Name of firewall client subnet id"
  value       = var.enable_firewall ? azurerm_subnet.firewall_client_snet[0].id : null
}

output "firewall_client_subnet_name" {
  description = "Name of gateway subnet"
  value       = var.enable_firewall ? azurerm_subnet.firewall_client_snet[0].name : null
}

output "firewall_management_subnet_id" {
  description = "Name of firewall management subnet id"
  value       = var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null ? azurerm_subnet.firewall_management_snet[0].id : null
}

output "firewall_management_subnet_name" {
  description = "Name of firewall management subnet"
  value       = var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null ? azurerm_subnet.firewall_management_snet[0].name : null
}

output "subnet_ids" {
  description = "Map of ids for default subnets"
  value = { for key, id in zipmap(
    sort(keys(var.hub_subnets)),
    sort(values(azurerm_subnet.default_snet)[*]["id"])) :
  key => { key = key, id = id } }
}

output "subnet_names" {
  description = "Map of names for default subnets"
  value = { for key, name in zipmap(
    sort(keys(var.hub_subnets)),
    sort(values(azurerm_subnet.default_snet)[*]["name"])) :
  key => { key = key, name = name } }
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = flatten(concat([for s in azurerm_subnet.default_snet : s.address_prefixes], [var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet[0].address_prefixes : null], [(var.enable_firewall) ? azurerm_subnet.firewall_client_snet[0].address_prefixes : null], [(var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null) ? azurerm_subnet.firewall_management_snet[0].address_prefixes : null]))
}

# Network Security group ids
output "network_security_group_ids" {
  description = "Map of ids for default NSGs"
  value = { for key, id in zipmap(
    sort(keys(var.hub_subnets)),
    sort(values(module.nsg)[*]["resource_id"])) :
  key => { key = key, id = id } }
}

output "network_security_group_names" {
  description = "Map of names for default NSGs"
  value = { for key, name in zipmap(
    sort(keys(var.hub_subnets)),
    sort(values(module.nsg)[*]["resource.name"])) :
  key => { key = key, name = name } }
}

# DDoS Protection Plan
output "ddos_protection_plan_id" {
  description = "Ddos protection plan details"
  value       = var.create_ddos_plan ? module.hub_vnet_ddos[0].resource.id : null
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = data.azurerm_network_watcher.nwatcher.id
}

output "route_table_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.routetable.name
}

output "route_table_id" {
  description = "The resource id of the route table"
  value       = azurerm_route_table.routetable.id
}

output "private_dns_zone_resource_group_name" {
  description = "The name of the Private DNS zones resource group within Azure DNS"
  value       = module.mod_dns_rg[0].resource_group_name
}

output "private_dns_zone_resource_ids" {
  description = "The IDs of the Private DNS zones within Azure DNS"
  value = { for key, id in zipmap(
    sort(local.if_default_private_dns_zones_enabled),
    sort(values(module.mod_default_pdz)[*]["private_dns_zone_id"])) :
  key => { key = key, id = id } }
}

output "private_dns_zone_names" {
  description = "The names of Private DNS zones within Azure DNS"
   value = { for key, name in zipmap(
    sort(local.if_default_private_dns_zones_enabled),
    sort(values(module.mod_default_pdz)[*]["private_dns_zone_name"])) :
  key => { key = key, name = name } }
}

output "hub_storage_account_id" {
  description = "The ID of the storage account."
  value       = module.hub_st.resource_id
}

output "hub_storage_account_name" {
  description = "The name of the storage account."
  value       = module.hub_st.name
}

output "public_ip_prefix_id" {
  description = "The id of the Public IP Prefix resource"
  value       = var.enable_firewall ? azurerm_public_ip_prefix.firewall_pref[0].id : null
}

output "firewall_client_public_ip" {
  description = "the public ip of firewall."
  value       = var.enable_firewall ? element(concat([for ip in module.hub_firewall_client_pip : ip.public_ip_address], [""]), 0) : null
}

output "firewall_management_public_ip" {
  description = "the public ip of firewall."
  value       = var.enable_firewall && var.enable_forced_tunneling ? element(concat([for ip in module.hub_firewall_management_pip : ip.public_ip_address], [""]), 0) : null
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = var.enable_firewall ? module.hub_fw[0].resource.ip_configuration[0].private_ip_address : null
}

output "firewall_id" {
  description = "The Resource ID of the Azure Firewall."
  value       = var.enable_firewall ? module.hub_fw[0].resource_id : null
}

output "firewall_name" {
  description = "The name of the Azure Firewall."
  value       = var.enable_firewall ? module.hub_fw[0].resource.name : null
}

output "firewall_dns_servers" {
  description = "The name of the Azure Firewall."
  value       = var.enable_firewall && var.enable_dns_proxy ? var.dns_servers : null
}

output "azure_bastion_subnet_id" {
  description = "The resource ID of Azure bastion subnet"
  value       = var.enable_bastion_host ? element(concat([azurerm_subnet.abs_snet[0].id], [""]), 0) : null
}

output "azure_bastion_public_ip" {
  description = "The public IP of the virtual network gateway"
  value       = var.enable_bastion_host ? module.hub_bastion_pip[0].public_ip_address : null
}

output "azure_bastion_host_id" {
  description = "The resource ID of the Bastion Host"
  value       = var.enable_bastion_host ? module.hub_bastion_host[0].bastion_resource.id : null
}

output "azure_bastion_host_fqdn" {
  description = "The resource ID of the Bastion Host"
  value       = var.enable_bastion_host ? module.hub_bastion_host[0].bastion_resource.dns_name : null
}
