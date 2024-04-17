# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################
# Firewall Configuration    ##
##############################

variable "enable_firewall" {
  description = "Controls if Azure Firewall resources should be created for the Azure subscription"
  type        = bool
  default     = true
}

variable "enable_forced_tunneling" {
  description = "Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet"
  type        = bool
  default     = true
}

variable "firewall_subnet_address_prefix" {
  description = "The address prefix to use for the Firewall subnet"
  type        = list(string)
  default     = []
}

variable "firewall_management_snet_address_prefix" {
  description = "The address prefix to use for Firewall management subnet to enable forced tunnelling. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a `/26`."
  type        = list(string)
  default     = null
}

variable "firewall_snet_service_endpoints" {
  description = "Service endpoints to add to the firewall client subnet"
  type        = list(string)
  default = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}

variable "firewall_snet_private_endpoint_network_policies_enabled" {
  description = "Controls if network policies are enabled on the firewall client subnet"
  type        = bool
  default     = false
}

variable "firewall_snet_private_link_service_network_policies_enabled" {
  description = "Controls if private link service network policies are enabled on the firewall client subnet"
  type        = bool
  default     = false
}

variable "firewall_management_snet_service_endpoints" {
  description = "Service endpoints to add to the firewall management subnet"
  type        = list(string)
  default     = []
}

variable "firewall_management_snet_private_endpoint_network_policies_enabled" {
  description = "Controls if network policies are enabled on the firewall management subnet"
  type        = bool
  default     = false
}

variable "firewall_management_snet_private_link_service_network_policies_enabled" {
  description = "Controls if private link service network policies are enabled on the firewall management subnet"
  type        = bool
  default     = false
}

variable "firewall_intrusion_detection_mode" {
  description = "Controls if Azure Firewall Intrusion Detection System (IDS) should be enabled for the Azure subscription"
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.firewall_intrusion_detection_mode)
    error_message = "The Intrusion Detection Mode must be either 'Alert' or 'Deny' or 'Off'. The default value is 'Alert'."
  }
}

variable "firewall_threat_intelligence_mode" {
  description = "Controls if Azure Firewall Threat Intelligence should be enabled for the Azure subscription"
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.firewall_threat_intelligence_mode)
    error_message = "The Threat Intelligence Mode must be either 'Alert' or 'Deny' or 'Off'. The default value is 'Alert'."
  }
}

variable "base_policy_id" {
  description = "The ID of the base policy to use for the Azure Firewall. This is used to create a new policy based on the base policy."
  type        = string
  default     = null
}

variable "firewall_sku_name" {
  description = "SKU name of the Firewall. Possible values are `AZFW_Hub` and `AZFW_VNet`"
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  description = "SKU tier of the Firewall. Defaults to 'Premium', Possible values are `Premium`, `Standard` and `Basic`"
  type        = string
  default     = "Premium"
}

variable "firewall_zones" {
  description = "A collection of availability zones to spread the Firewall over"
  type        = list(string)
  default     = null
}

variable "enable_dns_proxy" {
  description = "Controls if DNS Proxy should be enabled for the Azure subscription"
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "List of dns servers IPs to use for virtual network"
  type        = list(string)
  default     = null
}

variable "firewall_virtual_hub" {
  description = "An Azure Virtual WAN Hub with associated security and routing policies configured by Azure Firewall Manager. Use secured virtual hubs to easily create hub-and-spoke and transitive architectures with native security services for traffic governance and protection."
  type = object({
    virtual_hub_id  = string
    public_ip_count = number
  })
  default = null
}

##################################
# Firewall PIP Configuration    ##
##################################

variable "firewall_pip_sku" {
  description = "The SKU of the public IP address"
  type        = string
  default     = "Standard"
}

variable "firewall_pip_allocation_method" {
  description = "The allocation method of the public IP address"
  type        = string
  default     = "Static"
}
