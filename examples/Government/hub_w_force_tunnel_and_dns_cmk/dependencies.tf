# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#----------------------------------------------
# Log Analytics Workspace
#----------------------------------------------
data "azurerm_client_config" "root" {}

resource "azurerm_resource_group" "laws_rg" {
  name     = "laws-rg-${var.default_location}-${var.org_name}"
  location = var.default_location
}

resource "azurerm_log_analytics_workspace" "laws" {
  name                = "laws-${var.default_location}-${var.org_name}"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.laws_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = "30"
}

module "mod_shared_keyvault" {
  source    = "azure/avm-res-keyvault-vault/azurerm"
  version   = "0.9.1"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_key_vault_resource_group = false."   
  resource_group_name = azurerm_resource_group.laws_rg.name
  location            = var.default_location
  name                = "kv-${var.default_location}-${var.org_name}"
  tenant_id           = data.azurerm_client_config.root.tenant_id
  sku_name            = "standard"


  # This is to enable the soft delete for the key vault
  soft_delete_retention_days = 7

  # This is to enable the purge protection for the key vault
  purge_protection_enabled = true

  # This is to enable the deployments for the key vault
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  # This is to enable public access to the key vault, since we are using a private network and endpoint, we will disable it
  public_network_access_enabled = true

  # This is to enable the network access to the key vault
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["136.227.250.187"]
    virtual_network_subnet_ids = [
      module.mod_vnet_hub.subnet_ids["default"].id
    ]
  }

  # This is to enable the Customer Managed Keys for the key vault
  keys = {
    cmk_for_storage_account = {
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      key_type = "RSA"
      name     = "cmk-for-storage-account"
      key_size = 2048
    }
  }


  # This is to wait for the RBAC before the key operations
  wait_for_rbac_before_key_operations = {
    create = "120s"
  }

  # This is adding the current user as a Key Vault Roles. If CMK is enabled, the user and the UAI will be added to the Crypto Officer role.
  role_assignments = {
    deployment_user_kv_admin = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.root.object_id
    }
    deployment_user_certificates = {
      # give the deployment user access to certificates
      role_definition_id_or_name = "Key Vault Certificates Officer"
      principal_id               = data.azurerm_client_config.root.object_id
    }
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.root.object_id
    }
    cmk_admin_customer_managed_key = {
      role_definition_id_or_name = "Key Vault Crypto Officer"
      principal_id               = azurerm_user_assigned_identity.user_assigned_identity.principal_id
    }
  }

  # Telemetry
  enable_telemetry = true
}

# Create a User Assigned Identity for Azure Encryption
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  location            = var.default_location
  resource_group_name = azurerm_resource_group.laws_rg.name
  name                = "hub-st-usi"
}
