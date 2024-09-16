# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account for Log Archiving
#----------------------------------------------------------
module "hub_st" {
  depends_on                    = [module.mod_scaffold_rg, module.mod_dns_rg]
  source                        = "azure/avm-res-storage-storageaccount/azurerm"
  version                       = "0.2.7"
  resource_group_name           = local.resource_group_name
  name                          = local.hub_sa_name
  location                      = local.location
  account_kind                  = var.hub_storage_account_kind
  account_tier                  = var.hub_storage_account_tier
  account_replication_type      = var.hub_storage_account_replication_type
  public_network_access_enabled = true

  # Network Rules
  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = var.hub_storage_bypass_ip_cidr
    virtual_network_subnet_ids = toset([azurerm_subnet.default_snet["default"].id])
  }

  # Private Endpoint
  private_endpoints = {
    "blob" = {
      subnet_resource_id = azurerm_subnet.default_snet["default"].id
      subresource_name   = ["blob"]
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.hub_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  # Customer Managed Key
  customer_managed_key = var.enable_customer_managed_key ? {
    key_vault_resource_id              = var.key_vault_resource_id
    key_name                           = var.key_name
    user_assigned_identity_resource_id = var.user_assigned_identity_id
  } : null

  # Blob Properties
  containers = var.hub_storage_containers

  # Blob Properties
  blob_properties = {
    container_delete_retention_policy = {
      days = 30
    }
    delete_retention_policy = {
      days = 30
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("hubstdiaglogs%s", lower(replace(local.hub_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}
