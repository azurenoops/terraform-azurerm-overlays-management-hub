# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36"
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

#-------------------------------------
# Azure Provider Alias for Peering
#-------------------------------------
provider "azurerm" {
  alias                      = "ops_network"
  subscription_id            = coalesce(var.ops_subscription_id, data.azurerm_client_config.current.subscription_id)
  environment                = var.environment
  skip_provider_registration = var.environment == "usgovernment" ? true : false # Terraform auto registers more providers need by this module. Please see list of provider that are needed.
  features {}
}
