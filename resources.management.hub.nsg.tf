# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.hub_subnets
  name                = var.hub_nsg_custom_name != null ? "${var.hub_nsg_custom_name}_${each.key}" : "${data.azurenoopsutils_resource_name.nsg[each.key].result}"
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = lower("nsg_${each.key}") }, local.default_tags, var.add_tags, )
  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_subnet_inbound_rules", []), lookup(each.value, "nsg_subnet_outbound_rules", []))
    content {
      name                         = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                     = security_rule.value[1]
      direction                    = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                       = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                     = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range            = "*"
      destination_port_range       = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix        = security_rule.value[6] == "" ? element(each.value.address_prefixes, 0) : security_rule.value[6]
      destination_address_prefixes = security_rule.value[7] == [""] ? each.value.address_prefixes : security_rule.value[7]
      description                  = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  for_each                  = var.hub_subnets
  subnet_id                 = azurerm_subnet.default_snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

