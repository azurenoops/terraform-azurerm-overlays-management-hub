# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------

variable "enable_customer_managed_key" {
  type        = bool
  description = "Enable Customer Managed Key for Hub Storage Account."
  default     = false
}

variable "key_vault_resource_id" {
  type        = string
  description = "The ID of the Key Vault resource for Customer Managed Key for Hub Storage Account."
  default = null
}

variable "key_name" {
  type        = string
  description = "The name of the key in the Key Vault for Customer Managed Key for Hub Storage Account."
  default = null
}

variable "key_version" {
  type        = string
  description = "The version of the key in the Key Vault for Customer Managed Key for Hub Storage Account."
  default = null
}

variable "user_assigned_identity_id" {
  type        = string
  description = "The ID of the User Assigned Identity to use for Key Vault access for Customer Managed Key for Hub Storage Account."
  default = null
}
