# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = module.mod_vnet_hub.resource_group_name
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = module.mod_vnet_hub.resource_group_id
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = module.mod_vnet_hub.resource_group_location
}

#VNet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.mod_vnet_hub.virtual_network_name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.mod_vnet_hub.virtual_network_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = module.mod_vnet_hub.virtual_network_address_space
}

output "firewall_client_subnet_id" {
  description = "Name of firewall client subnet id"
  value       = module.mod_vnet_hub.firewall_client_subnet_id
}

output "firewall_client_subnet_name" {
  description = "Name of gateway subnet"
  value       = module.mod_vnet_hub.firewall_client_subnet_name
}

output "firewall_management_subnet_id" {
  description = "Name of firewall management subnet id"
  value       = module.mod_vnet_hub.firewall_management_subnet_id
}

output "firewall_management_subnet_name" {
  description = "Name of firewall management subnet"
  value       = module.mod_vnet_hub.firewall_management_subnet_name
}

output "subnet_ids" {
  description = "Map of IDs of subnets"
  value       = module.mod_vnet_hub.subnet_ids
}

output "subnet_names" {
  description = "Map of Names of subnets"
  value       = module.mod_vnet_hub.subnet_names
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = module.mod_vnet_hub.subnet_address_prefixes
}

output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = module.mod_vnet_hub.network_security_group_ids
}

output "network_security_group_names" {
  description = "List of Network security groups and ids"
  value       = module.mod_vnet_hub.network_security_group_names
}

# DDoS Protection plan
output "ddos_protection_plan_id" {
  description = "Ddos protection plan details"
  value       = module.mod_vnet_hub.ddos_protection_plan_id
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = module.mod_vnet_hub.network_watcher_id
}

# Route Table
output "route_table_name" {
  description = "The name of the route table"
  value       = module.mod_vnet_hub.route_table_name
}

output "route_table_id" {
  description = "The resource id of the route table"
  value       = module.mod_vnet_hub.route_table_id
}

# Storage Account
output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.mod_vnet_hub.hub_storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.mod_vnet_hub.hub_storage_account_name
}

# Public IP Prefix
output "public_ip_prefix_id" {
  description = "The id of the Public IP Prefix resource"
  value       = module.mod_vnet_hub.public_ip_prefix_id
}

# Firewall
output "firewall_client_public_ip" {
  description = "the public ip of firewall."
  value       = module.mod_vnet_hub.firewall_client_public_ip
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = module.mod_vnet_hub.firewall_private_ip
}

output "firewall_id" {
  description = "The Resource ID of the Azure Firewall."
  value       = module.mod_vnet_hub.firewall_id
}

output "firewall_name" {
  description = "The name of the Azure Firewall."
  value       = module.mod_vnet_hub.firewall_name
}

output "firewall_dns_servers" {
  description = "The DNS servers of the Azure Firewall."
  value       = module.mod_vnet_hub.firewall_dns_servers
}
