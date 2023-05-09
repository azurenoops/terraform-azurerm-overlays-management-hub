# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Operations Management Logging
#---------------------------------
module "mod_ops_logging" {
  providers = { azurerm = azurerm.ops_network }
  source  = "azurenoops/overlays-management-logging/azurerm"
  version = ">= 1.0.0"

  count = var.enable_management_logging ? 1 : 0

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = local.location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = "ops-mgt-logging"

  #############################
  ## Logging Configuration  ###
  #############################

  # (Optional) Logging Solutions
  # All solutions are enabled (true) by default
  enable_sentinel              = var.enable_sentinel
  enable_azure_activity_log    = var.enable_azure_activity_log
  enable_vm_insights           = var.enable_vm_insights
  enable_azure_security_center = var.enable_azure_security_center
  enable_container_insights    = var.enable_container_insights
  enable_key_vault_analytics   = var.enable_key_vault_analytics
  enable_service_map           = var.enable_service_map

  # (Required) To enable Azure Monitoring
  # Sku Name - Possible values are PerGB2018 and Free
  # Log Retention in days - Possible values range between 30 and 730
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days = var.log_analytics_logs_retention_in_days

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}
