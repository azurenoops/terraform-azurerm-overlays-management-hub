# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

provider "azurerm" {
  environment = var.environment
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }    
  }
  
}
