# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account Creation
#----------------------------------------------------------
module "mgt_sa" {
  depends_on                   = [module.mod_scaffold_rg]
  source                       = "azurenoops/overlays-storage-account/azurerm"
  version                      = "~> 1.0"
  existing_resource_group_name = local.resource_group_name
  storage_account_custom_name  = local.hub_sa_name
  location                     = local.location
  environment                  = var.environment
  deploy_environment           = var.deploy_environment
  workload_name                = var.workload_name
  org_name                     = var.org_name
  account_kind                 = var.hub_storage_account_kind
  account_tier                 = var.hub_storage_account_tier
  account_replication_type     = var.hub_storage_account_replication_type
  enable_resource_locks        = var.enable_resource_locks

  add_tags = merge({ "ResourceName" = format("hubstdiaglogs%s", lower(replace(local.hub_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}
