# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account Creation
#----------------------------------------------------------
module "hub_st" {
  depends_on               = [module.mod_scaffold_rg]
  source                   = "azure/avm-res-storage-storageaccount/azurerm"
  version                  = "~> 0.1"
  resource_group_name      = local.resource_group_name
  name                     = local.hub_sa_name
  location                 = local.location
  account_kind             = var.hub_storage_account_kind
  account_tier             = var.hub_storage_account_tier
  account_replication_type = var.hub_storage_account_replication_type

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.hub_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("hubstdiaglogs%s", lower(replace(local.hub_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}
