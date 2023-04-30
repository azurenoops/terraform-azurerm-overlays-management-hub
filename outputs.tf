# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "resource_group_name" {
  description = "The name of the hub virtual network resource group"
  value       = azurerm_virtual_network.hub_vnet.resource_group_name
}

output "virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = azurerm_virtual_network.hub_vnet.name
}

output "virtual_network_id" {
  description = "The id of the hub virtual network"
  value       = azurerm_virtual_network.hub_vnet.id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = element(coalescelist(azurerm_virtual_network.hub_vnet.*.address_space, [""]), 0)
}

output "ddos_protection_plan" {
  description = "Ddos protection plan details"
  value       = var.create_ddos_plan ? element(concat(azurerm_network_ddos_protection_plan.ddos.*.id, [""]), 0) : null
}

output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = var.create_network_watcher != false ? element(concat(azurerm_network_watcher.nwatcher.*.id, [""]), 0) : null
}

output "nsg_id" {
  description = "The id of the hub nsg"
  value       = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
  description = "The name of the hub nsg"
  value       = azurerm_network_security_group.nsg.name
}

output "default_subnet_id" {
  description = "The id of the default subnet"
  value       = element(concat(azurerm_subnet.default_snet.*.id, [""]), 0)
}

output "default_subnet_name" {
  description = "The name of the default subnet"
  value       = element(concat(azurerm_subnet.default_snet.*.name, [""]), 0)
}

output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = azurerm_firewall.fw.0.id
}

output "public_ip_prefix_id" {
  description = "The id of the Public IP Prefix resource"
  value       = azurerm_public_ip_prefix.fw-pref.0.id
}

output "firewall_public_ip" {
  description = "the public ip of firewall."
  value       = azurerm_firewall.fw.0.ip_configuration.0.public_ip_address_id
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = azurerm_firewall.fw.0.ip_configuration.0.private_ip_address
}

output "firewall_name" {
  description = "The name of the Azure Firewall."
  value       = azurerm_firewall.fw.0.name
}

output "virtual_private_ip_address" {
  description = "The private IP address associated with the Firewall"
  value       = var.virtual_hub != null ? azurerm_firewall.fw.0.virtual_hub.0.private_ip_address : null
}

output "virtual_public_ip_addresses" {
  description = "The private IP address associated with the Firewall"
  value       = var.virtual_hub != null ? azurerm_firewall.fw.0.virtual_hub.0.public_ip_addresses : null
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
