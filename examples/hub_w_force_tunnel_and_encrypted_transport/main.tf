# Azurerm provider configuration
provider "azurerm" {
  features {}
}

module "mod_logging" {
  source  = "azurenoops/overlays-management-logging/azurerm"
  version = ">= 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = "eastus"
  deploy_environment    = "dev"
  org_name              = "anoa"
  environment           = "public"
  workload_name         = "hub-test"

  #############################
  ## Logging Configuration  ###
  #############################

  # (Optional) Logging Solutions
  # All solutions are enabled (true) by default
  enable_sentinel           = true
  enable_azure_activity_log = true
  enable_vm_insights        = true

  # (Required) To enable Azure Monitoring
  # Sku Name - Possible values are PerGB2018 and Free
  # Log Retention in days - Possible values range between 30 and 730
  log_analytics_workspace_sku          = "PerGB2018"
  log_analytics_logs_retention_in_days = 30

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {
    Example = "Test Hub"
  } # Tags to be applied to all resources
}


module "mod_vnet_hub" {
  #source  = "azurenoops/overlays-management-hub/azurerm"
  #version = "x.x.x"
  source     = "../../"
  depends_on = [module.mod_logging]
  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location              = "eastus"
  deploy_environment    = "dev"
  org_name              = "anoa"
  environment           = "public"
  workload_name         = "hub-test"

  # Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
  virtual_network_address_space               = ["10.0.100.0/24"]              # (Required)  Hub Virtual Network Parameters  
  firewall_subnet_address_prefix              = ["10.0.100.0/26"]              # (Required)  Hub Firewall Subnet Parameters  
  create_ddos_plan                            = true                          # (Optional) Create DDOS Plan. Default is false
  create_network_watcher                      = true                           # (Optional) Hub Network Watcher
  log_analytics_workspace_name                = module.mod_logging.laws_name   # (Optional) Log Analytics Workspace Name for Network Watcher
  log_analytics_workspace_resource_group_name = module.mod_logging.laws_rgname # (Optional) Log Analytics Workspace Resource Group Name for Network Watcher

  # (Required) Hub Subnets 
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # First address ranges from VNet Address space reserved for Firewall Subnets. 
  # ex.: For 10.0.100.128/27 address space, usable address range start from 10.0.100.0/24 for all subnets.
  # default subnet name will be set as per Azure NoOps naming convention by defaut.
  # Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # NSG association to be added automatically for all subnets listed here.
  # First two address ranges from VNet Address space reserved for Gateway And Firewall Subnets. 
  # ex.: For 10.1.0.0/16 address space, usable address range start from 10.1.2.0/24 for all subnets.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  hub_subnets = {
    default_subnet = {
      name                                       = "hub-mgt"
      address_prefixes                           = ["10.0.100.64/27"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
    }
  }

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
  firewall_zones = [1, 2, 3]

  # # (Optional) specify the Network rules for Azure Firewall l
  # This is default values, do not need this if keeping default values
  firewall_network_rules_collection = [
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
  firewall_application_rule_collection = [
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

  # By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = true
  azure_bastion_host_sku              = "Standard"
  azure_bastion_subnet_address_prefix = ["10.0.100.160/27"]

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {
    Example = "Management Hub"
  } # Tags to be applied to all resources

  # (Optional) To enable Encrypted Transport on the enclave
  enable_encrypted_transport = true
  encrypted_transport_address_prefix = "10.3.0.0/16"
  encrypted_transport_next_hop_type = "VirtualAppliance"
  encrypted_transport_next_hop_in_ip_address = "10.2.0.33" 
}
