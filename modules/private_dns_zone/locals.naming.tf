# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  merged_tags = merge(local.default_tags, var.add_tags)

  # Private DNS Zone and Private DNS Zone VNet Link can have only 15 tags maximum
  truncated_tags = {
    for key in chunklist(keys(local.merged_tags), 14)[0] : key => lookup(local.merged_tags, key)
  }

  # We keep the 14 first tags, serialize all the others in a 15th one (JSON encoded)
  curtailed_tags = merge(
    local.truncated_tags,
    try({ "add_tags" = jsonencode({ for key in slice(keys(local.merged_tags), 14, length(local.merged_tags)) : key => lookup(local.merged_tags, key) }) }, {}),
  )
}
