
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##########################
# VNet Configuration    ##
##########################

variable "virtual_network_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = []
}

variable "create_ddos_plan" {
  description = "Create an ddos plan - Default is false"
  default     = false
}

variable "create_network_watcher" {
  description = "Controls if Network Watcher resources should be created for the Azure subscription. Default is false"
  default     = false
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace to be used for Azure Network Watcher"
  default     = null
}

variable "log_analytics_workspace_resource_group_name" {
  description = "The name of the resource group in which the Log Analytics Workspace is located"
  default     = null
}
