# Azurerm provider configuration
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "mod_vnet_hub" {
  #source  = "azurenoops/overlays-management-hub/azurerm"
  #version = "x.x.x"
  source = "../../"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location              = "eastus"
  deploy_environment    = "dev"
  org_name              = "anoa"
  environment           = "public"
  workload_name         = "hub-core"

  # Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
  virtual_network_address_space           = ["10.8.4.0/23"]     # (Required)  Hub Virtual Network Parameters  
  firewall_subnet_address_prefix          = ["10.8.4.64/26"]   # (Required)  Hub Firewall Subnet Parameters  
  ampls_subnet_address_prefix             = ["10.8.5.160/27"]   # (Required)  AMPLS Subnet Parameters
  firewall_management_snet_address_prefix = ["10.8.4.128/26"] # (Optional)  Hub Firewall Management Subnet Parameters
  gateway_subnet_address_prefix           = ["10.8.4.0/27"] # (Optional)  Hub Gateway Subnet Parameters

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
    default = {
      name                                       = "hub-core"
      address_prefixes                           = ["10.8.4.224/27"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
    }

    dmz = {
      name                                       = "appgateway"
      address_prefixes                           = ["10.8.5.64/27"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
      nsg_subnet_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        # 65200-65335 port to be opened if you planning to create application gateway
        ["http", "100", "Inbound", "Allow", "Tcp", "80", "*", ["0.0.0.0/0"]],
        ["https", "200", "Inbound", "Allow", "Tcp", "443", "*", [""]],
        ["appgwports", "300", "Inbound", "Allow", "Tcp", "65200-65335", "*", [""]],

      ]
      nsg_subnet_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["ntp_out", "400", "Outbound", "Allow", "Udp", "123", "", ["0.0.0.0/0"]],
      ]
    }
  }

  # By default, this will module will deploy management logging.
  # If you do not want to enable management logging, 
  # set enable_management_logging to false.
  # All Log solutions are enabled (true) by default. To disable a solution, set the argument to `enable_<solution_name> = false`.
  enable_management_logging = true

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

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = ["privatelink.file.core.windows.net"]

  # By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = true
  azure_bastion_host_sku              = "Standard"
  azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {
    Example = "Management Hub"
  } # Tags to be applied to all resources
}
