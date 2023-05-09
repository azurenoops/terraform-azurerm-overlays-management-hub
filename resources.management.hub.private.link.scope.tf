# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_monitor_private_link_scope" "global_pls" {
  name                = local.privateLinkScopeName
  resource_group_name = module.mod_ops_logging.0.laws_rgname
}

resource "azurerm_monitor_private_link_scoped_service" "laws_pls" {
  depends_on = [
    azurerm_monitor_private_link_scope.global_pls,
    module.mod_ops_logging
  ]
  name                = local.privateLinkScopeResourceName
  resource_group_name = module.mod_ops_logging.0.laws_rgname
  scope_name          = azurerm_monitor_private_link_scope.global_pls.name
  linked_resource_id  = module.mod_ops_logging.0.laws_resource_id
}