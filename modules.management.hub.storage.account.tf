# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account for Log Archiving
#----------------------------------------------------------
module "hub_st" {
  depends_on = [module.mod_scaffold_rg, module.mod_dns_rg, azurerm_user_assigned_identity.user_assigned_identity]
  source     = "azure/avm-res-storage-storageaccount/azurerm"
  version    = "0.2.7"

  // Globals
  resource_group_name = local.resource_group_name
  name                = local.hub_sa_name
  location            = local.location

  // Account 
  account_kind              = var.hub_storage_account_kind
  account_tier              = var.hub_storage_account_tier
  account_replication_type  = var.hub_storage_account_replication_type
  shared_access_key_enabled = true

  // Marked as true for PE
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
      subnet_resource_id            = azurerm_subnet.default_snet["default"].id
      subresource_name              = "blob"
      private_dns_zone_resource_ids = [var.environment == "public" ? module.mod_default_pdz["privatelink.blob.core.windows.net"].private_dns_zone_id : module.mod_default_pdz["privatelink.blob.core.usgovcloudapi.net"].private_dns_zone_id]
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.hub_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  # Managed Idenities
  managed_identities = var.enable_customer_managed_key ? {
    system_assigned            = true
    user_assigned_resource_ids = [azurerm_user_assigned_identity.user_assigned_identity[0].id]
  } : {
      system_assigned            = true
      user_assigned_resource_ids = length(var.hub_storage_user_assigned_resource_ids) > 0 ? var.hub_storage_user_assigned_resource_ids : []
  }

  # Customer Managed Key
  customer_managed_key = var.enable_customer_managed_key ? {
    key_vault_resource_id  = var.key_vault_resource_id
    key_name               = var.key_name
    user_assigned_identity = { resource_id = azurerm_user_assigned_identity.user_assigned_identity[0].id }
  } : null

  # Role Assignments
  role_assignments = {
    role_assignment_uai = {
      role_definition_id_or_name       = "Storage Blob Data Contributor"
      principal_id                     = coalesce(azurerm_user_assigned_identity.user_assigned_identity[0].id, data.azurerm_client_config.current.object_id)
      skip_service_principal_aad_check = false
    },
    role_assignment_current_user = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },
  }

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

  // Storage Diagnostic Settings
  diagnostic_settings_blob = {
    sendToLogAnalytics = {
      name                           = "sendToLogAnalytics_storage"
      workspace_resource_id          = var.log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("hubstdiaglogs%s", lower(replace(local.hub_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}


# Create a User Assigned Identity for Azure Encryption
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  count               = var.enable_customer_managed_key ? 1 : 0
  location            = local.location
  resource_group_name = local.resource_group_name
  name                = "hub_sa_usi"
}
