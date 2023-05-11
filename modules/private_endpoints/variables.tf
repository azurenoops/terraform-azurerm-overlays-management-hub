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

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet in which the Private Endpoint will be created."
  type        = string
}

variable "is_manual_connection" {
  description = "Does the Private Endpoint require manual approval from the remote resource owner? Default to `false`."
  type        = bool
  default     = false
}

variable "request_message" {
  description = "A message passed to the owner of the remote resource when the Private Endpoint attempts to establish the connection to the remote resource. Only valid if `is_manual_connection` is set to `true`."
  type        = string
  default     = "Private Endpoint Deployment"
}

variable "target_resource" {
  description = "Private Link Service Alias or ID of the target resource."
  type        = string

  validation {
    condition     = length(regexall("^([a-z0-9\\-]+)\\.([a-z0-9\\-]+)\\.([a-z]+)\\.(azure)\\.(privatelinkservice)$", var.target_resource)) == 1 || length(regexall("^\\/(subscriptions)\\/([a-z0-9\\-]+)\\/(resourceGroups)\\/([A-Za-z0-9\\-_]+)\\/(providers)\\/([A-Za-z\\.]+)\\/([A-Za-z]+)\\/([A-Za-z0-9\\-]+)$", var.target_resource)) == 1
    error_message = "The `target_resource` variable must be a Private Link Service Alias or a resource ID."
  }
}

variable "subresource_name" {
  description = "Name of the subresource corresponding to the target Azure resource. Only valid if `target_resource` is not a Private Link Service."
  type        = string
  default     = ""
}

variable "use_existing_private_dns_zones" {
  description = "Boolean to create the Private DNS Zones corresponding to the Private Endpoint. If you wish to centralize the Private DNS Zones in another Resource Group that could belong to another subscription, set this option to `true` and use the `private-dns-zone` submodule directly."
  type        = bool
  default     = false
}

variable "private_dns_zones_ids" {
  description = "IDs of the Private DNS Zones in which a new record will be created for the Private Endpoint. Only valid if `use_existing_private_dns_zones` is set to `true` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified."
  type        = list(string)
  default     = []
}

variable "private_dns_zones_names" {
  description = "Names of the Private DNS Zones to create. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified."
  type        = list(string)
  default     = []
}

variable "private_dns_zones_vnets_ids" {
  description = "IDs of the VNets to link to the Private DNS Zones. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service."
  type        = list(string)
  default     = []
}