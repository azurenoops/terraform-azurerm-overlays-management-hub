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

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = module.mod_vnet_hub.subnet_ids
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = module.mod_vnet_hub.subnet_address_prefixes
}

output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = module.mod_vnet_hub.network_security_group_ids
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

output "route_table_name" {
  description = "The name of the route table"
  value       = module.mod_vnet_hub.route_table_name
}

output "route_table_id" {
  description = "The resource id of the route table"
  value       = module.mod_vnet_hub.route_table_id
}

output "private_dns_zone_names" {
  description = "The names of the Private DNS zones within Azure DNS"
  value       = module.mod_vnet_hub.private_dns_zone_names
}

output "private_dns_zone_ids" {
  description = "The resource ids of Private DNS zones within Azure DNS"
  value       = module.mod_vnet_hub.private_dns_zone_ids
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.mod_vnet_hub.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.mod_vnet_hub.storage_account_name
}

output "storage_primary_access_key" {
  sensitive   = true
  description = "The primary access key for the storage account."
  value       = module.mod_vnet_hub.storage_primary_access_key
}

output "public_ip_prefix_id" {
  description = "The id of the Public IP Prefix resource"
  value       = module.mod_vnet_hub.public_ip_prefix_id
}

output "firewall_client_public_ip" {
  description = "the public ip of firewall."
  value       = module.mod_vnet_hub.firewall_client_public_ip
}

output "firewall_client_public_ip_fqdn" {
  description = "Fully qualified domain name of the A DNS record associated with the public IP."
  value       = module.mod_vnet_hub.firewall_client_public_ip_fqdn
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