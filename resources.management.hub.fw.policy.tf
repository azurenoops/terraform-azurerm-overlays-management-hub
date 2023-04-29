# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a firewall policy in the Hub Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Firewall Policy 
                  * Application Rule Collection Group
                    * Application Rule Collection
                        * Application Rule
                    * Network Rule Collection Group
                    * Network Rule Collection
                        * Network Rule             
AUTHOR/S: jspinella
*/

#----------------------------------------------
# Azure Firewall Policy / Rules 
#----------------------------------------------
resource "azurerm_firewall_policy" "firewallpolicy" {
  name                     = local.hub_fw_policy_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  sku                      = var.firewall_config.sku_tier
  base_policy_id           = var.base_policy_id == null ? null : var.base_policy_id
  threat_intelligence_mode = var.fw_threat_intelligence_mode
  dynamic "intrusion_detection" {
    for_each = var.firewall_config.sku_tier == "Premium" ? [1] : []
    content {
      mode = var.fw_intrusion_detection_mode
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "app_rule_collection_group" {
  name               = "${local.hub_fw_policy_name}-default-arcg"
  firewall_policy_id = azurerm_firewall_policy.firewallpolicy.id
  priority           = "300"

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collection
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name = rule.value.name
          protocols {
            type = rule.value.protocols.type
            port = rule.value.protocols.port
          }                                                                         # list  
          source_addresses      = lookup(rule.value, "source_addresses", null)      # list
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)      # list Specifies a list of source IP groups.
          destination_addresses = lookup(rule.value, "destination_addresses", null) # list - ["192.168.1.1", "192.168.1.2"]
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null)     # list of destination IP groups.
        }
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "nw_rule_collection_group" {
  name               = "${local.hub_fw_policy_name}-default-nwrcg"
  firewall_policy_id = azurerm_firewall_policy.firewallpolicy.id
  priority           = "100"

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collection
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols                              # list
          source_addresses      = lookup(rule.value, "source_addresses", null)      # list
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)      # list Specifies a list of source IP groups.
          destination_addresses = lookup(rule.value, "destination_addresses", null) # list - ["192.168.1.1", "192.168.1.2"]
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", null) # list of destination IP groups.
          destination_ports     = lookup(rule.value, "destination_ports", null)     # list of destination ports.
        }
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "nat_rule_collection_group" {
  name               = "${local.hub_fw_policy_name}-default-natrcg"
  firewall_policy_id = azurerm_firewall_policy.firewallpolicy.id
  priority           = "110"

  dynamic "nat_rule_collection" {
    for_each = var.nat_rule_collections
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols                            # list
          destination_ports   = rule.value.destination_ports                    # list - Required
          source_addresses    = lookup(rule.value, "source_addresses", null)    # list
          source_ip_groups    = lookup(rule.value, "source_ip_groups", null)    # list Specifies a list of source IP groups.
          destination_address = lookup(rule.value, "destination_address", null) # string - "192.168.1.1"
          translated_port     = lookup(rule.value, "translated_port", null)     # string - "8080"
        }
      }
    }
  }
}
