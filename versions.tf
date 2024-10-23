# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.9.2"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.3"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# workaround for AVM-Resource module
provider "azapi" {
  environment = var.environment
}