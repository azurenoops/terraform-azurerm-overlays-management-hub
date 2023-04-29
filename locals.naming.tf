# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name    = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location               = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  hub_vnet_name          = coalesce(var.hub_vnet_custom_name, data.azurenoopsutils_resource_name.vnet.result)
  hub_snet_name          = coalesce(var.hub_snet_custom_name, "${data.azurenoopsutils_resource_name.snet.result}")
  hub_nsg_name           = coalesce(var.hub_nsg_custom_name, "${data.azurenoopsutils_resource_name.nsg.result}")
  hub_fw_name            = coalesce(var.hub_fw_custom_name, "${data.azurenoopsutils_resource_name.fw.result}")
  hub_fw_policy_name     = coalesce(var.hub_fw_policy_custom_name, "${data.azurenoopsutils_resource_name.fw_policy.result}")
  hub_fw_client_pip_name = coalesce(var.hub_fw_client_pip_custom_name, "${data.azurenoopsutils_resource_name.fw_client_pub_ip.result}")
  hub_fw_mgt_pip_name    = coalesce(var.hub_fw_mgt_pip_custom_name, "${data.azurenoopsutils_resource_name.fw_mgt_pub_ip.result}")
  hub_rt_name            = coalesce(var.hub_routtable_custom_name, "${data.azurenoopsutils_resource_name.rt.result}")
  hub_sa_name            = coalesce(var.hub_sa_custom_name, data.azurenoopsutils_resource_name.st.result)

  # Bastion Host
  bastion_name     = coalesce(var.bastion_custom_name, "${data.azurenoopsutils_resource_name.bastion.result}")
  bastion_pip_name = coalesce(var.bastion_pip_custom_name, "${data.azurenoopsutils_resource_name.bastion_pip.result}")
}
