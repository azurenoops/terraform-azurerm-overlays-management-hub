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

################################
# Landing Zone Configuration  ##
################################

#########################
# Management Logging  ###
#########################

variable "ampls_subnet_address_prefixes" {
  description = "A name for the ops logging. It defaults to ops-logging-core."
  type        = list(string)
  default     = ["10.8.5.160/27"]
}

variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018."
  type        = string
  default     = null
}

variable "log_analytics_logs_retention_in_days" {
  description = "The number of days to retain logs for. Possible values are between 30 and 730. Default is 30."
  type        = number
  default     = null
}

#####################################
# Log Solutions Configuration     ##
#####################################

variable "enable_sentinel" {
  description = "Controls if Sentinel should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "enable_azure_activity_log" {
  description = "Controls if Azure Activity Log should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "enable_vm_insights" {
  description = "Controls if VM Insights should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "enable_azure_security_center" {
  description = "Controls if Azure Security Center should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "enable_service_map" {
  description = "Controls if Service Map should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "enable_container_insights" {
  description = "Controls if Container Insights should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "enable_key_vault_analytics" {
  description = "Controls if Key Vault Analytics should be enabled. Default is true."
  type        = bool
  default     = true
}


##########
# Hub  ###
##########

variable "hub_name" {
  description = "Name of the hub network name. This will be used to name the resources deployed by this module. default is 'hub-core'"
  type        = string
  default     = "hub-core"
}

variable "hub_vnet_address_space" {
  description = "The address space of the hub virtual network."
  type        = list(string)
  default     = ["10.8.4.0/23"]
}

variable "hub_subnets" {
  description = "The subnets of the hub virtual network."
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
  type        = list(string)
  default     = []
}

variable "firewall_supernet_IP_address" {
  description = "The IP address of the firewall supernet."
  type        = string
  default     = "10.0.96.0/19"
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
  description = "The zones of the firewall. Valid values are 1, 2, and 3."
  default     = null
}

variable "enable_firewall" {
  description = "Enables an Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_application_rules" {
  description = "List of application rules to apply to firewall."
  default     = {}
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  default     = {}
}

variable "firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  default     = {}
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