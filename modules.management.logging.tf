# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Operations Management Logging
#---------------------------------
resource "azurerm_subnet" "pe_snet" {
  count                                         = var.enable_ampls ? 1 : 0
  name                                          = format("%s-%s-ampls-%s-snet", var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : local.location, var.deploy_environment)
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.ampls_subnet_address_prefix
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}

module "mod_ops_logging" {
  providers  = { azurerm = azurerm.ops_network }
  source     = "azurenoops/overlays-management-logging/azurerm"
  version    = "~> 2.0"
  depends_on = [azurerm_subnet.pe_snet]

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = local.location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = "ops-logging"

  #############################
  ## Logging Configuration  ###
  #############################

  # (Optional) Logging Solutions
  # All solutions are enabled (true) by default
  enable_sentinel              = false
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

  # Enable Azure Monitor Private Link Scope
  enable_ampls = var.enable_ampls

  # AMPLS Network Configuration
  existing_network_resource_group_name = local.resource_group_name
  existing_virtual_network_name        = azurerm_virtual_network.hub_vnet.name
  existing_private_subnet_name         = azurerm_subnet.pe_snet.0.name

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
