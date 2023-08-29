# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Operations Management Logging
#---------------------------------
module "mod_ops_logging" {
  providers = { azurerm = azurerm.ops_network }
  source    = "azurenoops/overlays-management-logging/azurerm"
  version   = "~> 1.0"

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
  log_analytics_workspace_sku                   = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days          = var.log_analytics_logs_retention_in_days
  loganalytics_storage_account_kind             = var.log_analytics_storage_account_kind
  loganalytics_storage_account_tier             = var.log_analytics_storage_account_tier
  loganalytics_storage_account_replication_type = var.log_analytics_storage_account_replication_type

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = merge(local.default_tags, var.add_tags, ) # Tags to be applied to all resources
}

#---------------------------------
# Management Logging Storage Account
#---------------------------------
/* resource "azurerm_log_analytics_linked_storage_account" "mgt_loganalytics_st_alerts_link" {
  depends_on = [ module.mod_ops_logging, module.mgt_sa ]
  data_source_type      = "Alerts"
  resource_group_name   = local.resource_group_name
  workspace_resource_id = module.mod_ops_logging.0.laws_resource_id
  storage_account_ids   = [module.mgt_sa.storage_account_id]
} */
