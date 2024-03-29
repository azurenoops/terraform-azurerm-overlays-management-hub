# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------
# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# No vars should be referenced elsewhere in the module.
# NOTE: Need to catch error for resource_suffix when
# no value for subscription_id is provided.
locals {
  settings      = var.private_dns_zones
}

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

locals {
  if_ddos_enabled = var.create_ddos_plan ? [{}] : []
}

# Configuration settings for resource type:
#  - azurerm_private_dns_zone
locals {
  if_default_private_dns_zones_enabled = var.enable_default_private_dns_zones ? (var.environment == "public" ?
  ["privatelink.azure-api.net", "privatelink.developer.azure-api.net","privatelink.azconfig.io","privatelink.his.arc.azure.com",
  "privatelink.guestconfiguration.azure.com", "privatelink.kubernetesconfiguration.azure.com","privatelink.azure-automation.net",
  "privatelink.azure-automation.net","privatelink.batch.azure.com","privatelink.directline.botframework.com","privatelink.token.botframework.com",
  "privatelink.redis.cache.windows.net","privatelink.redisenterprise.cache.azure.net","privatelink.azurecr.io","privatelink.cassandra.cosmos.azure.com",
  "privatelink.gremlin.cosmos.azure.com","privatelink.mongo.cosmos.azure.com","privatelink.documents.azure.com","privatelink.table.cosmos.azure.com",
  "privatelink.datafactory.azure.net","privatelink.adf.azure.com","privatelink.azurehealthcareapis.com", "privatelink.dicom.azurehealthcareapis.com",
  "privatelink.dfs.core.windows.net","privatelink.mariadb.database.azure.com","privatelink.mysql.database.azure.com",
  "privatelink.postgres.database.azure.com","privatelink.digitaltwins.azure.net","privatelink.eventgrid.azure.net","privatelink.eventgrid.azure.net",
  "privatelink.servicebus.windows.net","privatelink.afs.azure.net","privatelink.azurehdinsight.net","privatelink.azure-devices-provisioning.net",
  "privatelink.azure-devices.net", "privatelink.servicebus.windows.net","privatelink.vaultcore.azure.net","privatelink.managedhsm.azure.net",
  "privatelink.api.azureml.ms", "privatelink.notebooks.azure.net","privatelink.blob.core.windows.net","privatelink.media.azure.net",
  "privatelink.prod.migration.windowsazure.com","privatelink.monitor.azure.com", "privatelink.oms.opinsights.azure.com", "privatelink.ods.opinsights.azure.com",
  "privatelink.agentsvc.azure-automation.net", "privatelink.blob.core.windows.net","privatelink.purview.azure.com","privatelink.purviewstudio.azure.com",
  "privatelink.servicebus.windows.net","privatelink.search.windows.net","privatelink.servicebus.windows.net","privatelink.siterecovery.windowsazure.com",
  "privatelink.database.windows.net","privatelink.dev.azuresynapse.net","privatelink.sql.azuresynapse.net","privatelink.azuresynapse.net",
  "privatelink.azurewebsites.net","privatelink.azurestaticapps.net","privatelink.cognitiveservices.azure.com","privatelink.analysis.windows.net",
  "privatelink.pbidedicated.windows.net", "privatelink.tip1.powerquery.microsoft.com","privatelink.service.signalr.net","privatelink.webpubsub.azure.com",
  "privatelink.blob.core.windows.net","privatelink.file.core.windows.net","privatelink.queue.core.windows.net","privatelink.table.core.windows.net",
  "privatelink.web.core.windows.net", "privatelink.${var.location}.backup.windowsazure.com", "privatelink.${var.location}.kusto.windows.net",
  "privatelink.${var.location}.azmk8s.io"] :
  ["privatelink.cognitiveservices.azure.us","privatelink.api.ml.azure.us","privatelink.servicebus.usgovcloudapi.net", "privatelink.sql.azuresynapse.usgovcloudapi.net",
  "privatelink.sql.azuresynapse.usgovcloudapi.net", "privatelink.dev.azuresynapse.usgovcloudapi.net", "privatelink.azuresynapse.usgovcloudapi.net", "privatelink.datafactory.azure.us",
  "privatelink.adf.azure.us","privatelink.azurehdinsight.us", "privatelink.databricks.azure.us", "privatelink.batch.usgovcloudapi.net", "privatelink-global.wvd.azure.us", "privatelink.wvd.azure.us",
  "privatelink.azurecr.us", "${var.location}.privatelink.azurecr.us", "privatelink.database.usgovcloudapi.net", "privatelink.documents.azure.us", "privatelink.mongo.cosmos.azure.us",
  "privatelink.postgres.database.usgovcloudapi.net", "privatelink.mysql.database.usgovcloudapi.net", "privatelink.mariadb.database.usgovcloudapi.net", "privatelink.redis.cache.usgovcloudapi.net",
  "privatelink.servicebus.usgovcloudapi.net","privatelink.eventgrid.azure.us", "privatelink.azure-devices.us", "privatelink.azure-automation.us", "privatelink.${var.location}.backup.windowsazure.us",
  "privatelink.siterecovery.windowsazure.us", "privatelink.monitor.azure.us", "privatelink.purview.azure.us", "privatelink.purviewstudio.azure.us", "privatelink.vaultcore.usgovcloudapi.net", "privatelink.azconfig.azure.us",
  "privatelink.blob.core.usgovcloudapi.net", "privatelink.table.core.usgovcloudapi.net", "privatelink.queue.core.usgovcloudapi.net", "privatelink.file.core.usgovcloudapi.net","privatelink.web.core.usgovcloudapi.net",
  "privatelink.dfs.core.usgovcloudapi.net", "privatelink.search.windows.us", "privatelink.servicebus.usgovcloudapi.net", "privatelink.azurewebsites.us"]) : var.private_dns_zones
}
