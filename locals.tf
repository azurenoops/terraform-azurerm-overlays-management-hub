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