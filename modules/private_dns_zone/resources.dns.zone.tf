# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name = var.private_dns_zone_name

  resource_group_name = var.resource_group_name
  tags = local.curtailed_tags

  lifecycle {
    precondition {
      condition     = var.is_not_private_link_service
      error_message = "Private Link Service does not require the deployment of Private DNS Zones."
    }
  }
}