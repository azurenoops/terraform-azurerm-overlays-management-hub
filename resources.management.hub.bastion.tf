# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an Bastion Host with Jumpboxes to the Hub Virtual Network
DESCRIPTION: The following components will be options in this deployment
            * Bastion Host with Jumpboxes    
AUTHOR/S: jspinella
*/
#####################################
### Bastion Host Configuration    ###
#####################################

resource "random_string" "str" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    domain_name_label = var.azure_bastion_service_name
  }
}

#-----------------------------------------------------------------------
# Subnets Creation for Azure Bastion Service - at least /27 or larger.
#-----------------------------------------------------------------------
resource "azurerm_subnet" "abs_snet" {
  count                                         = (var.enable_bastion_host && var.azure_bastion_subnet_address_prefix != null) ? 1 : 0
  name                                          = "AzureBastionSubnet"
  resource_group_name                           = local.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.azure_bastion_subnet_address_prefix
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}

#---------------------------------------------
# Public IP for Azure Bastion Service
#---------------------------------------------
resource "azurerm_public_ip" "bastion_pip" {
  count               = var.enable_bastion_host ? 1 : 0
  name                = local.bastion_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = var.azure_bastion_public_ip_allocation_method
  sku                 = var.azure_bastion_public_ip_sku
  domain_name_label   = var.domain_name_label != null ? var.domain_name_label : format("gw%s%s", lower(replace(local.bastion_pip_name, "/[[:^alnum:]]/", "")), random_string.str.result)
  tags                = merge({ "ResourceName" = local.bastion_pip_name }, local.default_tags, var.add_tags, )

  lifecycle {
    ignore_changes = [
      tags,
      ip_tags,
    ]
  }
}

#---------------------------------------------
# Azure Bastion Service host
#---------------------------------------------
resource "azurerm_bastion_host" "main" {
  count                  = var.enable_bastion_host ? 1 : 0
  name                   = local.bastion_name
  resource_group_name    = local.resource_group_name
  location               = local.location
  copy_paste_enabled     = var.enable_copy_paste
  file_copy_enabled      = var.azure_bastion_host_sku == "Standard" ? var.enable_file_copy : null
  sku                    = var.azure_bastion_host_sku
  ip_connect_enabled     = var.enable_ip_connect
  scale_units            = var.azure_bastion_host_sku == "Standard" ? var.scale_units : 2
  shareable_link_enabled = var.azure_bastion_host_sku == "Standard" ? var.enable_shareable_link : null
  tunneling_enabled      = var.azure_bastion_host_sku == "Standard" ? var.enable_tunneling : null
  tags                   = merge({ "ResourceName" = lower(local.bastion_name) }, local.default_tags, var.add_tags, )

  ip_configuration {
    name                 = "${lower(local.bastion_name)}-network"
    subnet_id            = azurerm_subnet.abs_snet.0.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.0.id
  }
}
