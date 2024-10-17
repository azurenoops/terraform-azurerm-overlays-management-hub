# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_vnet_hub" {
  #source  = "azurenoops/overlays-management-hub/azurerm"
  #version = "x.x.x"
  source = "../../.."

  depends_on = [ azurerm_log_analytics_workspace.laws, azurerm_key_vault.kv, azurerm_key_vault_key.kv_key]

  ####################################
  # Management Hub Virtual Network  ##
  ####################################

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name,
  # and set the argument to `create_hub_resource_group = false`. Location will be same as existing RG.
  create_hub_resource_group = true
  location                  = var.default_location
  deploy_environment        = var.deploy_environment
  org_name                  = var.org_name
  environment               = var.environment
  workload_name             = var.hub_name

  # Provide valid VNet Address space and specify valid domain name for Private DNS Zone.
  virtual_network_address_space           = var.hub_vnet_address_space              # (Required)  Hub Virtual Network Parameters
  firewall_subnet_address_prefix          = var.fw_client_snet_address_prefixes     # (Required)  Hub Firewall Subnet Parameters
  firewall_management_snet_address_prefix = var.fw_management_snet_address_prefixes # (Optional)  Hub Firewall Management Subnet Parameters

  # (Required) Log Analytics Workspace for Network Diagnostic Settings & Traffic Analytics
  existing_log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
  existing_log_analytics_workspace_id          = azurerm_log_analytics_workspace.laws.workspace_id

  # (Optional) Enable DDos Protection Plan
  create_ddos_plan = var.create_ddos_plan

  # (Optional) Enable Customer Managed Key for Azure Storage Account
  enable_customer_managed_keys = true
  # Uncomment the following lines to enable Customer Managed Key for Azure Hub Storage Account
  key_vault_resource_id       = azurerm_key_vault.kv.id
  key_name                    = "cmk-for-storage-account"
  
  # (Required) Hub Subnets
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # subnet name will be set as per Azure NoOps naming convention by default. expected value here is: <App or project name>
  hub_subnets = var.hub_subnets

  # (Optional) Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # (Required) Firewall Settings
  # By default, Azure NoOps will create Azure Firewall in Hub VNet.
  # If you do not want to create Azure Firewall,
  # set enable_firewall to false. This will allow different firewall products to be used (Example: F5).
  enable_firewall = var.enable_firewall

  # (Optional) By default, forced tunneling is enabled for Azure Firewall.
  # If you do not want to enable forced tunneling,
  # set enable_forced_tunneling to false.
  enable_forced_tunneling = var.enable_forced_tunneling

  # (Optional) To enable the availability zones for firewall.
  # Availability Zones can only be configured during deployment
  # You can't modify an existing firewall to include Availability Zones
  firewall_zones = var.firewall_zones

  # # (Optional) specify the Network rules for Azure Firewall l
  # This is default values, do not need this if keeping default values
  firewall_network_rules_collection = var.firewall_network_rules

  # (Optional) specify the application rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  firewall_application_rule_collection = var.firewall_application_rules

  # (Optional) specify the nat rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  firewall_nat_rule_collection = var.firewall_nat_rules

  # (Optional) Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones in Hub VNet.
  # If you do want to create additional Private DNS Zones,
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.hub_private_dns_zones

  # (Optional) By default, this module will create a bastion host,
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = var.enable_bastion_host
  azure_bastion_host_sku              = var.azure_bastion_host_sku
  azure_bastion_subnet_address_prefix = var.azure_bastion_subnet_address_prefix

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.tags # Tags to be applied to all resources
}
