# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

########################################
# Management Logging Configuration    ##
########################################

variable "enable_management_logging" {
  description = "Enable Management Logging for Operations Logging. **IMPORTANT** `enable_management_logging` should only be used with the operations tier."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_logs_retention_in_days" {
  description = "The retention period for logs in days. Possible values range between 30 and 730. Default is 30."
  type        = number
  default     = 30
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