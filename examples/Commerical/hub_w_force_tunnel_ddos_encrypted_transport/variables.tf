# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Global Configuration
#################################
variable "environment" {
  description = "Name of the environment. This will be used to name the private endpoint resources deployed by this module. default is 'public'"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environnement (dev, test, prod, etc). This will be used to name the resources deployed by this module. default is 'dev'"
  type        = string
}

variable "org_name" {
  description = "Name of the organization. This will be used to name the resources deployed by this module. default is 'anoa'"
  type        = string
  default     = "anoa"
}

variable "default_location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = "eastus"
}

#################################
# Resource Lock Configuration
#################################

variable "enable_resource_locks" {
  type        = bool
  description = "If set to true, will enable resource locks for all resources deployed by this module where supported."
  default     = false
}

variable "lock_level" {
  description = "The level of lock to apply to the resources. Valid values are CanNotDelete, ReadOnly, or NotSpecified."
  type        = string
  default     = "CanNotDelete"
}

######################################
# Customer Managed Keys Configuration
######################################

variable "enable_customer_managed_key" {
  description = "If set to true, will enable customer managed keys for all resources deployed by this module where supported."
  type        = bool
  default     = false
}

################################
# Landing Zone Configuration  ##
################################

##########
# Hub  ###
##########

variable "hub_name" {
  description = "Name of the hub network name. This will be used to name the resources deployed by this module. default is 'hub'"
  type        = string
  default     = "hub"
}

variable "hub_vnet_address_space" {
  description = "The address space of the hub virtual network."
  type        = list(string)
  default     = ["10.8.4.0/23"]
}

variable "hub_subnets" {
  description = "The subnets of the hub virtual network."
  type = map(object({
    #Basic info for the subnet
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = bool
    private_endpoint_service_endpoints_enabled = bool

    # Delegation block - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))

    #Subnet NSG rules - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#security_rule
    nsg_subnet_rules = optional(list(object({
      name                                       = string
      description                                = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    })))
  }))
  default     = {}
}

variable "create_ddos_plan" {
  description = "Create a DDoS protection plan for the hub virtual network."
  type        = bool
  default     = true
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}

variable "hub_private_dns_zones" {
  description = "The private DNS zones of the hub virtual network."
  type        = any
  default     = {}
}

variable "fw_client_snet_address_prefixes" {
  description = "The address prefix of the firewall subnet."
  type        = list(string)
  default     = ["10.8.4.64/26"]
}

variable "fw_management_snet_address_prefixes" {
  description = "The address prefix of the firewall subnet."
  type        = list(string)
  default     = ["10.8.4.128/26"]
}

variable "firewall_zones" {
  description = "A collection of availability zones to spread the Firewall over"
  type        = list(string)
  default     = null
}

variable "enable_firewall" {
  description = "Enables an Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_application_rules" {
  description = "List of application rules to apply to firewall."
  type = any
  default     = []
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  type = any
  default     = []
}

variable "firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type = any
  default     = []
}

variable "enable_forced_tunneling" {
  description = "Enables Force Tunneling for Azure Firewall"
  type        = bool
  default     = true
}

variable "enable_bastion_host" {
  description = "Enables an Azure Bastion Host"
  type        = bool
  default     = true
}

variable "azure_bastion_host_sku" {
  description = "The SKU of the Azure Bastion Host. Possible values are Standard and Basic. Default is Standard."
  type        = string
  default     = "Standard"
}

variable "azure_bastion_subnet_address_prefix" {
  description = "The address prefix of the Azure Bastion Host subnet."
  type        = list(string)
  default     = null
}

variable "enable_dns_proxy" {
  description = "Enable [true/false] The Azure Firewall DNS Proxy will forward all DNS traffic. When this value is set to true, you must provide a value for 'dns_servers'."
  type        = bool
  default     = true
}

variable "dns_servers" {
  description = "['168.63.129.16'] The Azure Firewall DNS Proxy will forward all DNS traffic. When this value is set to true, you must provide a value for 'dns_servers'. This should be a comma separated list of IP addresses to forward DNS traffic."
  type        = list(string)
  default     = ["168.63.129.16"]
}

variable "hub_storage_bypass_ip_cidr" {
  description = "The CIDRs for Azure Storage Account. This will allow the specified CIDRs to bypass the Azure Firewall for Azure Storage Account."
  type        = list(string)
  default     = []
}

#######################################
# Encrypted Transport Configuration  ##
#######################################

variable "enable_encrypted_transport" {
  description = "Enables encrypted transport for the hub virtual network. Default is false."
  type        = bool
  default     = false
}

variable "encrypted_transport_address_prefix" {
  description = "The address prefix of the encrypted transport subnet."
  type        = string
  default     = null
}

variable "encrypted_transport_next_hop_in_ip_address" {
  description = "The next hop in IP address of the encrypted transport subnet."
  type        = string
  default     = null
}

variable "encrypted_transport_next_hop_type" {
  description = "The next hop type of the encrypted transport subnet. Valid values are VirtualAppliance and VnetLocal."
  type        = string
  default     = null
}
