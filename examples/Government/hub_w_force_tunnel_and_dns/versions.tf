# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

provider "azurerm" {
  environment = "usgovernment"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
