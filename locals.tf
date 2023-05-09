# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 5
}

locals {
  if_ddos_enabled = var.create_ddos_plan ? [{}] : []

  # AMPLS DNS Zones
  privateDnsZones_privatelink_monitor_azure_name             = (var.environment == "public" ? "privatelink.monitor.azure.com" : "privatelink.monitor.azure.us")
  privateDnsZones_privatelink_ods_opinsights_azure_name      = (var.environment == "public" ? "privatelink.ods.opinsights.azure.com" : "privatelink.ods.opinsights.azure.us")
  privateDnsZones_privatelink_oms_opinsights_azure_name      = (var.environment == "public" ? "privatelink.oms.opinsights.azure.com" : "privatelink.oms.opinsights.azure.us")
  privateDnsZones_privatelink_blob_core_cloudapi_net_name    = (var.environment == "public" ? "privatelink.blob.core.windows.net" : "privatelink.blob.core.usgovcloudapi.net")
  privateDnsZones_privatelink_agentsvc_azure_automation_name = (var.environment == "public" ? "privatelink.agentsvc.azure-automation.net" : "privatelink.agentsvc.azure-automation.us")

  privateLinkConnectionName    = "plconn${module.mod_ops_logging.0.laws_name}${random_id.uniqueString.hex}"
  privateLinkEndpointName      = "pl${module.mod_ops_logging.0.laws_name}${random_id.uniqueString.hex}"
  privateLinkScopeName         = "plscope${module.mod_ops_logging.0.laws_name}${random_id.uniqueString.hex}"
  privateLinkScopeResourceName = "plscres${module.mod_ops_logging.0.laws_name}${random_id.uniqueString.hex}"
  
  ample_dns_zones = [
    local.privateDnsZones_privatelink_monitor_azure_name,
    local.privateDnsZones_privatelink_ods_opinsights_azure_name,
    local.privateDnsZones_privatelink_oms_opinsights_azure_name,
    local.privateDnsZones_privatelink_blob_core_cloudapi_net_name,
    local.privateDnsZones_privatelink_agentsvc_azure_automation_name
  ]
}
