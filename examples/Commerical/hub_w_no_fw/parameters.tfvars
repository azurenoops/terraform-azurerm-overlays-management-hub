# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
## Global Configuration  ##
###########################

# The prefixes to use for all resources in this deployment
org_name           = "an3"   # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"    # dev | test | prod
environment        = "public" # public | usgovernment

# The default region to deploy to
default_location = "eastus"

# Enable locks on resources
enable_resource_locks = false # true | false

################################
# Landing Zone Configuration  ##
################################

#######################################
# 01 Management Hub Virtual Network  ##
#######################################

# (Required)  Hub Virtual Network Parameters
# Provide valid VNet Address space and specify valid domain name for Private DNS Zone.
hub_vnet_address_space              = ["10.8.4.0/23"]   # (Required)  Hub Virtual Network Parameters

# (Required) DDOS Protection Plan
# By default, Azure NoOps will create DDOS Protection Plan in Hub VNet.
# If you do not want to create DDOS Protection Plan,
# set create_ddos_plan to false.
create_ddos_plan = true

# (Optional) Customer Managed Keys
# Azure NoOps can create Customer Managed Keys in Hub VNet.
# If you do not want to create Customer Managed Keys,
# set enable_customer_managed_key to false.
enable_customer_managed_key = false

# (Required) Hub Subnets
# Default Subnets, Service Endpoints
# This is the default subnet with required configuration, check README.md for more details
# First address ranges from VNet Address space reserved for Firewall Subnets.
# First three address ranges from VNet Address space reserved for Gateway, AMPLS And Firewall Subnets.
# ex.: For 10.8.4.0/23 address space, usable address range start from "10.8.4.224/27" for all subnets.
# default subnet name will be set as per Azure NoOps naming convention by default.
# Multiple Subnets, Service delegation, Service Endpoints, Network security groups
# These are default subnets with required configuration, check README.md for more details
# NSG association to be added automatically for all subnets listed here.
# subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
hub_subnets = {
  default = {
    name                                       = "hub"
    address_prefixes                           = ["10.8.4.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  },
}

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

#################################
# 02 Management Hub Firewall ###
#################################

# Firewall Settings
# By default, Azure NoOps will create Azure Firewall in Hub VNet.
# If you do not want to create Azure Firewall,
# set enable_firewall to false. This will allow different firewall products to be used (Example: F5).
enable_firewall = false

# (Optional) By default, forced tunneling is enabled for Azure Firewall.
# If you do not want to enable forced tunneling,
# set enable_forced_tunneling to false.
enable_forced_tunneling = false

#######################################
# 03 Bastion/Hub Private DNS Zones ###
#######################################

# Private DNS Zone Settings
# By default, Azure NoOps will create default Private DNS Zones in Hub VNet.
# If you do want to create additional Private DNS Zones,
# add in the list of hub_private_dns_zones to be created.
# else, remove the hub_private_dns_zones argument.
hub_private_dns_zones            = []

# By default, this module will create a bastion host,
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]

