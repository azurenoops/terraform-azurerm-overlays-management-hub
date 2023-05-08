# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################
# Generic naming Configuration    ##
####################################
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_naming" {
  description = "Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_resource_group_name" {
  description = "The name of the resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "custom_logging_resource_group_name" {
  description = "The name of the logging resource group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_vnet_custom_name" {
  description = "The name of the custom virtual network to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_firewall_custom_name" {
  description = "The name of the custom virtual network firewall to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_firewall_policy_custom_name" {
  description = "The name of the custom virtual network firewall policy to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_snet_custom_name" {
  description = "The name of the custom virtual network subnet to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_nsg_custom_name" {
  description = "The name of the custom virtual network network security group to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_firewall_client_pip_custom_name" {
  description = "The name of the custom virtual network firewall client public IP to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_firewall_mgt_pip_custom_name" {
  description = "The name of the custom virtual network firewall management public IP to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_routtable_custom_name" {
  description = "The name of the custom virtual network route table to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "hub_sa_custom_name" {
  description = "The name of the custom virtual network storage account to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "bastion_custom_name" {
  description = "The name of the custom bastion host to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "bastion_pip_custom_name" {
  description = "The name of the custom bastion host pip to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}


variable "ops_logging_sa_custom_name" {
  description = "The name of the custom operational logging storage account to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "ops_logging_law_custom_name" {
  description = "The name of the custom operational logging laws workspace to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' and 'name_suffix' variables will be ignored."
  type        = string
  default     = null
}

variable "ddos_plan_custom_name" {
  description = "The name of the custom ddos protection plan to create. If not set, the name will be generated using the 'name_prefix' and 'name_suffix' variables. If set, the 'name_prefix' variable will be ignored."
  type        = string
  default     = null
}


