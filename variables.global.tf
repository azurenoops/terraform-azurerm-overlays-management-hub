# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environnement"
  type        = string
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
}

variable "disable_telemetry" {
  description = "If set to true, will disable the telemetry sent as part of the module."
  type        = string
  default     = true
}

#######################
# RG Configuration   ##
#######################

variable "create_hub_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided by existing_resource_group_name variable. Default is false."
  type        = bool
  default     = false
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

############################
# Hub DNS Configuration   ##
############################

variable "existing_private_dns_zone_blob_id" {
  description = "Specifies the name of the private DNS zone blob id"
  type        = string
  default     = null
}

#######################
# LAW Configuration  ##
#######################

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
  default = null
}

variable "log_analytics_workspace_resource_id" {
  description = "Log Analytics Workspace Resource ID"
  type        = string
  default = null
}
