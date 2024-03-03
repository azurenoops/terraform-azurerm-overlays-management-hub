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

# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# The following locals identify the module
locals {
  org_name          = var.org_name
  disable_telemetry = var.disable_telemetry

  # PUID identifies the module
  telem_management_hub_puid = "434fc92b-dbc0-4770-8642-f611851881bd5"
}

# The following `can()` is used for when disable_telemetry = true
locals {
  telem_random_hex = can(random_id.telem[0].hex) ? random_id.telem[0].hex : local.empty_string
}

# Here we create the ARM templates for the telemetry deployment
locals {
  telem_arm_subscription_template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {
    "telemetry": {
      "type": "String",
      "value": "For more information, see https://aka.ms/azurenoops/tf/telemetry"
    }
  }
}
TEMPLATE
}

