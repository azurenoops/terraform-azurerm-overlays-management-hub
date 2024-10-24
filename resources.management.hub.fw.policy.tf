# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Firewall Policy with optional rule collections
DESCRIPTION: The following components will be options in this deployment
              * Firewall Policy
                  * Application Rule Collection Group
                    * Application Rule Collection
                        * Application Rule
                    * Network Rule Collection Group
                    * Network Rule Collection
                        * Network Rule
AUTHOR/S: jrspinella
*/

#----------------------------------------------
# Azure Firewall Policy / Rules
#----------------------------------------------
module "hub_firewall_policy" {
  source  = "azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.3.1"
  count   = var.enable_firewall ? 1 : 0

  # Resource Group
  name                                     = local.hub_firewall_policy_name
  resource_group_name                      = local.resource_group_name
  location                                 = local.location
  firewall_policy_sku                      = var.firewall_sku_tier
  firewall_policy_base_policy_id           = var.base_policy_id == null ? null : var.base_policy_id
  firewall_policy_threat_intelligence_mode = var.firewall_threat_intelligence_mode
  firewall_policy_dns = var.firewall_sku_tier == "Premium" || var.firewall_sku_tier == "Standard" ? {
    proxy_enabled = var.enable_dns_proxy
    servers       = var.dns_servers
  } : null

  firewall_policy_intrusion_detection = var.firewall_sku_tier == "Premium" ? {
    mode = var.firewall_intrusion_detection_mode
  } : null

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", local.hub_firewall_policy_name, var.lock_level)
    kind = var.lock_level
  } : null

  # telemtry
  enable_telemetry = var.enable_telemetry
}

module "hub_fw_app_rule_collection_group" {
  depends_on = [module.hub_firewall_policy]
  source     = "azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version    = "0.3.1"

  count = var.enable_firewall ? 1 : 0

  firewall_policy_rule_collection_group_name               = format("%s-default-arcg", local.hub_firewall_policy_name)
  firewall_policy_rule_collection_group_firewall_policy_id = module.hub_firewall_policy[0].resource.id
  firewall_policy_rule_collection_group_priority           = "300"

  # Rule Collections
  firewall_policy_rule_collection_group_application_rule_collection = var.firewall_application_rule_collection
}

module "hub_fw_nat_rule_collection_group" {
  depends_on = [module.hub_firewall_policy]
  source     = "azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version    = "0.3.1"

  count = var.enable_firewall ? 1 : 0

  firewall_policy_rule_collection_group_name               = format("%s-default-nrcg", local.hub_firewall_policy_name)
  firewall_policy_rule_collection_group_firewall_policy_id = module.hub_firewall_policy[0].resource.id
  firewall_policy_rule_collection_group_priority           = "110"

  # Rule Collections
  firewall_policy_rule_collection_group_nat_rule_collection = var.firewall_nat_rule_collection
}

module "hub_fw_nw_rule_collection_group" {
  depends_on = [module.hub_firewall_policy]
  source     = "azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version    = "0.3.1"

  count = var.enable_firewall ? 1 : 0

  firewall_policy_rule_collection_group_name               = format("%s-default-nwrcg", local.hub_firewall_policy_name)
  firewall_policy_rule_collection_group_firewall_policy_id = module.hub_firewall_policy[0].resource.id
  firewall_policy_rule_collection_group_priority           = "100"

  # Rule Collections
  firewall_policy_rule_collection_group_network_rule_collection = var.firewall_network_rules_collection
}
