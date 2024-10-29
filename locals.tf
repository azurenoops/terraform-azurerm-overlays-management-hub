# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Random ID
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourcePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 5
}

# Configuration settings for resource type:
#  - azurerm_private_dns_zone
locals {
  if_default_private_dns_zones_enabled = (var.environment == "public" && var.enable_private_dns_zones ?
    [ "privatelink.azure-api.net", "privatelink.developer.azure-api.net", "privatelink.azconfig.io", "privatelink.azure-automation.net",
      "privatelink.redis.cache.windows.net", "privatelink.${var.location}.azurecr.io", "privatelink.cassandra.cosmos.azure.com", "privatelink.mongo.cosmos.azure.com", "privatelink.documents.azure.com",
      "privatelink.table.cosmos.azure.com", "privatelink.datafactory.azure.net", "privatelink.dfs.core.windows.net", "privatelink.mariadb.database.azure.com", "privatelink.mysql.database.azure.com",
      "privatelink.postgres.database.azure.com", "privatelink.digitaltwins.azure.net", "privatelink.eventgrid.azure.net", "privatelink.servicebus.windows.net",
      "privatelink.vaultcore.azure.net", "privatelink.managedhsm.azure.net", "privatelink.api.azureml.ms", "privatelink.blob.core.windows.net", "privatelink.purview.azure.com",
      "privatelink.purviewstudio.azure.com", "privatelink.siterecovery.windowsazure.com", "privatelink.database.windows.net", "privatelink.dev.azuresynapse.net",
      "privatelink.sql.azuresynapse.net", "privatelink.azuresynapse.net", "privatelink.cognitiveservices.azure.com", "privatelink.analysis.windows.net", "privatelink.service.signalr.net", "privatelink.file.core.windows.net", "privatelink.queue.core.windows.net", "privatelink.table.core.windows.net",
      "privatelink.${var.location}.backup.windowsazure.com", "privatelink.agentsvc.azure-automation.net", "privatelink.monitor.azure.com", "privatelink.ods.opinsights.azure.com",  "privatelink.oms.opinsights.azure.com", "privatelink.developer.azure-api.azure.us",  "privatelink.${var.location}.kusto.windows.net", "privatelink.${var.location}.azmk8s.io"] :
    (var.environment == "usgovernment" && var.enable_private_dns_zones ? ["privatelink.cognitiveservices.azure.us", "privatelink.api.ml.azure.us", "privatelink.azure-api.azure.us", "privatelink.sql.azuresynapse.usgovcloudapi.net",
      "privatelink.dev.azuresynapse.usgovcloudapi.net", "privatelink.azuresynapse.usgovcloudapi.net", "privatelink.datafactory.azure.us",
      "privatelink.adf.azure.us", "privatelink.azurehdinsight.us", "privatelink.databricks.azure.us", "privatelink.batch.usgovcloudapi.net", "privatelink-global.wvd.azure.us", "privatelink.wvd.azure.us",
      "privatelink.${var.location}.azurecr.us", "privatelink.database.usgovcloudapi.net", "privatelink.documents.azure.us", "privatelink.mongo.cosmos.azure.us", "privatelink.cassandra.cosmos.azure.us", "privatelink.table.cosmos.azure.us",
      "privatelink.postgres.database.usgovcloudapi.net", "privatelink.mysql.database.usgovcloudapi.net", "privatelink.mariadb.database.usgovcloudapi.net", "privatelink.redis.cache.usgovcloudapi.net",
      "privatelink.servicebus.usgovcloudapi.net", "privatelink.eventgrid.azure.us", "privatelink.azure-automation.us", "privatelink.${var.location}.backup.windowsazure.us",
      "privatelink.siterecovery.windowsazure.us", "privatelink.purview.azure.us", "privatelink.purviewstudio.azure.us", "privatelink.vaultcore.usgovcloudapi.net", "privatelink.azconfig.azure.us",
      "privatelink.blob.core.usgovcloudapi.net", "privatelink.table.core.usgovcloudapi.net", "privatelink.queue.core.usgovcloudapi.net", "privatelink.file.core.usgovcloudapi.net",
      "privatelink.dfs.core.usgovcloudapi.net", "privatelink.${var.location}.azmk8s.us", "privatelink.monitor.azure.us", "privatelink.adx.monitor.azure.us",
      "privatelink.oms.opinsights.azure.us", "privatelink.ods.opinsights.azure.us", "privatelink.agentsvc.azure-automation.us"] : null))
}
