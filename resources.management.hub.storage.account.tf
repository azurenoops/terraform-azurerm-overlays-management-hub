# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account Creation
#----------------------------------------------------------
resource "azurerm_storage_account" "storeacc" {
  name                      = local.hub_sa_name
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  tags                      = merge({ "ResourceName" = format("hubstdiaglogs%s", lower(replace(local.hub_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}
