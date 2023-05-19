# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, module.mod_scaffold_rg.*.resource_group_id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
}

# Vnet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = element(concat(azurerm_virtual_network.hub_vnet.*.name, [""]), 0)
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = element(concat(azurerm_virtual_network.hub_vnet.*.id, [""]), 0)
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = element(coalescelist(azurerm_virtual_network.hub_vnet.*.address_space, [""]), 0)
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = flatten(concat([for s in azurerm_subnet.default_snet : s.id], [azurerm_subnet.pe_snet.id], [var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet.0.id : null], [azurerm_subnet.firewall_client_snet.0.id], [(var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null) ? azurerm_subnet.firewall_management_snet.0.id : null]))
}

output "subnet_names" {
  description = "List of names of subnet"
  value       = flatten(concat([for s in azurerm_subnet.default_snet : s.name], [azurerm_subnet.pe_snet.name], [var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet.0.name : null], [azurerm_subnet.firewall_client_snet.0.name], [(var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null) ? azurerm_subnet.firewall_management_snet.0.name : null]))
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = flatten(concat([for s in azurerm_subnet.default_snet : s.address_prefixes], [azurerm_subnet.pe_snet.address_prefixes], [var.gateway_subnet_address_prefix != null ? azurerm_subnet.gw_snet.0.address_prefixes : null], [azurerm_subnet.firewall_client_snet.0.address_prefixes], [(var.enable_forced_tunneling && var.firewall_management_snet_address_prefix != null) ? azurerm_subnet.firewall_management_snet.0.address_prefixes : null]))
}

# Network Security group ids
output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = [for n in azurerm_network_security_group.nsg : n.id]
}

# DDoS Protection Plan
output "ddos_protection_plan_id" {
  description = "Ddos protection plan details"
  value       = var.create_ddos_plan ? element(concat(azurerm_network_ddos_protection_plan.ddos.*.id, [""]), 0) : null
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = element(concat(azurerm_network_watcher.nwatcher.*.id, [""]), 0)
}

output "route_table_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.routetable.name
}

output "route_table_id" {
  description = "The resource id of the route table"
  value       = azurerm_route_table.routetable.id
}

output "private_dns_zone_names" {
  description = "The name of the Private DNS zones within Azure DNS"
  value       = [for s in module.mod_ampls_pdz : s.private_dns_zone_name] 
}

output "private_dns_zone_ids" {
  description = "The resource id of Private DNS zones within Azure DNS"
  value       = [for s in module.mod_ampls_pdz : s.private_dns_zone_id] 
}

output "ampls_private_dns_zone_ids" {
  description = "The name of the Private DNS zones within Azure DNS"
  value       = module.mod_ampls_main_private_endpoint.private_dns_zones_ids
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.mgt_sa.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.mgt_sa.storage_account_name
}

output "public_ip_prefix_id" {
  description = "The id of the Public IP Prefix resource"
  value       = azurerm_public_ip_prefix.firewall_pref.0.id
}

output "firewall_client_public_ip" {
  description = "the public ip of firewall."
  value       = element(concat([for ip in azurerm_public_ip.firewall_client_pip : ip.ip_address], [""]), 0)
}

output "firewall_client_public_ip_fqdn" {
  description = "Fully qualified domain name of the A DNS record associated with the public IP."
  value       = element(concat([for f in azurerm_public_ip.firewall_client_pip : f.fqdn], [""]), 0)
}

output "firewall_management_public_ip" {
  description = "the public ip of firewall."
  value       = element(concat([for ip in azurerm_public_ip.firewall_management_pip : ip.ip_address], [""]), 0)
}

output "firewall_management_public_ip_fqdn" {  
  description = "Fully qualified domain name of the A DNS record associated with the public IP."
  value       = element(concat([for f in azurerm_public_ip.firewall_management_pip : f.fqdn], [""]), 0)
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = azurerm_firewall.fw.0.ip_configuration.0.private_ip_address
}

output "firewall_id" {
  description = "The Resource ID of the Azure Firewall."
  value       = azurerm_firewall.fw.0.id
}

output "firewall_name" {
  description = "The name of the Azure Firewall."
  value       = azurerm_firewall.fw.0.name
}

output "azure_bastion_subnet_id" {
  description = "The resource ID of Azure bastion subnet"
  value       = var.enable_bastion_host ? element(concat([azurerm_subnet.abs_snet.0.id], [""]), 0) : null
}

output "azure_bastion_public_ip" {
  description = "The public IP of the virtual network gateway"
  value       = var.enable_bastion_host ? element(concat([azurerm_public_ip.bastion_pip.0.ip_address], [""]), 0) : null
}

output "azure_bastion_public_ip_fqdn" {
  description = "Fully qualified domain name of the virtual network gateway"
  value       = var.enable_bastion_host ? element(concat([azurerm_public_ip.bastion_pip.0.fqdn], [""]), 0) : null
}

output "azure_bastion_host_id" {
  description = "The resource ID of the Bastion Host"
  value       = var.enable_bastion_host ? azurerm_bastion_host.main.0.id : null
}

output "azure_bastion_host_fqdn" {
  description = "The fqdn of the Bastion Host"
  value       = var.enable_bastion_host ? azurerm_bastion_host.main.0.dns_name : null
}

output "managmement_logging_log_analytics_id" {
  description = "The resource ID of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_resource_id 
}

output "managmement_logging_log_analytics_name" {
  description = "The name of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_name 
}

output "managmement_logging_log_analytics_resource_group" {
  description = "The rg of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_rgname 
}

output "managmement_logging_log_analytics_workspace_id" {
  description = "The rg of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_workspace_id 
}

output "managmement_logging_log_analytics_primary_shared_key" {
  description = "The rg of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_primary_shared_key 
}

output "managmement_logging_storage_account_id" {
  description = "The resource ID of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_storage_account_id 
}

output "managmement_logging_storage_account_name" {
  description = "The name of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_storage_account_name 
}

output "managmement_logging_storage_account_resource_group" {
  description = "The rg of the management logging log analytics workspace"
  value       = module.mod_ops_logging.laws_storage_account_rgname 
}