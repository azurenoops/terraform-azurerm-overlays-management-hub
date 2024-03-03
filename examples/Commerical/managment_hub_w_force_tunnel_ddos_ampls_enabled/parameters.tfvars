# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
## Global Configuration  ##
###########################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"   # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"    # dev | test | prod
environment        = "public" # public | usgovernment

# The default region to deploy to
default_location = "eastus"

# Enable locks on resources
enable_resource_locks = false # true | false

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

################################
# Landing Zone Configuration  ##
################################

#######################################
# 05 Management Hub Virtual Network  ##
#######################################

# (Required)  Hub Virtual Network Parameters   
# Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
hub_vnet_address_space              = ["10.8.4.0/23"]   # (Required)  Hub Virtual Network Parameters  
fw_client_snet_address_prefixes     = ["10.8.4.64/26"]  # (Required)  Hub Firewall Subnet Parameters  
fw_management_snet_address_prefixes = ["10.8.4.128/26"] # (Optional)  Hub Firewall Management Subnet Parameters. If not provided, force_tunneling is not needed. 

# (Required) DDOS Protection Plan
# By default, Azure NoOps will create DDOS Protection Plan in Hub VNet.
# If you do not want to create DDOS Protection Plan,
# set create_ddos_plan to false.
create_ddos_plan = true

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
    name                                       = "hub-core"
    address_prefixes                           = ["10.8.4.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "allow-443",
        description                = "Allow access to port 443",
        priority                   = 100,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_range     = "443",
        source_address_prefix      = "*",
        destination_address_prefix = "*"
      }
    ]
  },
}

########################################
# 05a Management OperationL Logging  ###
########################################

# Enable Azure Montior Private Link Scope
enable_ampls = true
ampls_subnet_address_prefix         = ["10.8.5.160/27"] # (Optional)  AMPLS Subnet Parameter

# Log Analytics Workspace Settings
log_analytics_workspace_sku          = "PerGB2018"
log_analytics_logs_retention_in_days = 30

# Azure Monitor Settings
# All solutions are enabled (true) by default
enable_azure_activity_log    = true
enable_vm_insights           = true
enable_azure_security_center = true
enable_container_insights    = true
enable_key_vault_analytics   = true
enable_service_map           = true

#################################
# 05b Management Hub Firewall ###
#################################

# Firewall Settings
# By default, Azure NoOps will create Azure Firewall in Hub VNet. 
# If you do not want to create Azure Firewall, 
# set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
enable_firewall = true

# By default, forced tunneling is enabled for Azure Firewall.
# If you do not want to enable forced tunneling, 
# set enable_forced_tunneling to false.
enable_forced_tunneling = true


# (Optional) To enable the availability zones for firewall. 
# Availability Zones can only be configured during deployment 
# You can't modify an existing firewall to include Availability Zones
# In Azure Government, Availability Zones are only supported in the 
#following regions: usgovvirginia, usgovtexas, usgovarizona
firewall_zones = []

# # (Optional) specify the Network rules for Azure Firewall l
# This is default values, do not need this if keeping default values
firewall_network_rules = [
  {
    name     = "AllowAzureCloud"
    priority = "100"
    action   = "Allow"
    rules = [
      {
        name                  = "AzureCloud"
        protocols             = ["Any"]
        source_addresses      = ["*"]
        destination_addresses = ["AzureCloud"]
        destination_ports     = ["*"]
      }
    ]
  },
  {
    name     = "AllowTrafficBetweenSpokes"
    priority = "200"
    action   = "Allow"
    rules = [
      {
        name                  = "AllSpokeTraffic"
        protocols             = ["Any"]
        source_addresses      = ["10.96.0.0/19"]
        destination_addresses = ["*"]
        destination_ports     = ["*"]
      }
    ]
  }
]

# (Optional) specify the application rules for Azure Firewall
# This is default values, do not need this if keeping default values
firewall_application_rules = [
  {
    name     = "AzureAuth"
    priority = "110"
    action   = "Allow"
    rules = [
      {
        name              = "msftauth"
        source_addresses  = ["*"]
        destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
        protocols = {
          type = "Https"
          port = 443
        }
      }
    ]
  }
]

#######################################
# 05c Bastion/Hub Private DNS Zones ###
#######################################

# Private DNS Zone Settings
# By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
# If you do want to create additional Private DNS Zones, 
# add in the list of private_dns_zones to be created.
# else, remove the private_dns_zones argument.
hub_private_dns_zones = []

# By default, this module will create a bastion host, 
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]

