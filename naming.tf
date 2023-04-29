# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#2 Random ID for naming
resource "random_id" "id" {
  byte_length = 3
}

data "azurenoopsutils_resource_name" "vnet" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_network"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "vnet"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "fw" {
  name          = var.workload_name
  resource_type = "azurerm_firewall"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "afw"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "fw_policy" {
  name          = var.workload_name
  resource_type = "azurerm_firewall_policy"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "afwp"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "snet" {
  name          = var.workload_name
  resource_type = "azurerm_subnet"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "snet"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "fw_client_pub_ip" {
  name          = var.workload_name
  resource_type = "azurerm_public_ip"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, "fw-client", var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "fw_mgt_pub_ip" {
  name          = var.workload_name
  resource_type = "azurerm_public_ip"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, "fw-management", var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "nsg" {
  name          = var.workload_name
  resource_type = "azurerm_network_security_group"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "nsg"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "rt" {
  name          = var.workload_name
  resource_type = "azurerm_route_table"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "route-table"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "st" {
  name          = random_id.uniqueString.hex
  resource_type = "azurerm_storage_account"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "st"])
  use_slug      = var.use_naming
}

data "azurenoopsutils_resource_name" "bastion" {
  name          = var.workload_name
  resource_type = "azurerm_bastion_host"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "bas"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "bastion_pip" {
  name          = var.workload_name
  resource_type = "azurerm_public_ip"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, "bas", var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
