# Azure Virtual Network Management Hub with Firewall Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-management-hub/azurerm/)

This Overlay Terraform module deploys a Management Hub network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). Usually, only one hub in each region with multiple spokes and each of the spokes can also be in separate subscriptions.

## SCCA Compliance

This module is be SCCA compliant and can be used in a SCCA compliant Network. Enable SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Management Hub Architecture

The following reference architecture shows how to implement a SCCA compliant hub-spoke topology in Azure. The Management hub is a virtual network in Azure that acts as a central point of connectivity to an optional on-premises network. The spokes are virtual networks that peer with the Management hub and can be used to isolate workloads. Traffic flows between the on-premises datacenter and the hub can be achieved through an ExpressRoute or VPN gateway connection.

AzureFirewallSubnet and GatewaySubnet will not contain any UDR (User Defined Route) or NSG/Rules (Network Security Group). Management and DMZ subnets will route all outgoing traffic through firewall instance.

Source: [Microsoft Azure Hub-Spoke Topology Documentation](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)

![Architecture](./docs/images/mission_enclave_hub_simple.png)

## Resources Supported

* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Subnet Service Delegation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#delegation)
* [Virtual Network service endpoints](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_endpoints)
* [Private Link service/Endpoint network policies on Subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#enforce_private_link_endpoint_network_policies)
* [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)
* [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
* [Azure Firewall](https://www.terraform.io/docs/providers/azurerm/r/firewall.html)
* [Azure Firewall Application Rule Collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html)
* [Azure Firewall Network Rule Collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html)
* [Azure Firewall NAT Rule Collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html)
* [Route Table](https://www.terraform.io/docs/providers/azurerm/r/route_table.html)
* [Role Assignment for Peering](https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html)
* [Storage Account for Log Archive](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html)
* [Log Analytics Workspace](https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html)
* [Azure Monitoring Diagnostics](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
* [Network Watcher Workflow Logs](https://www.terraform.io/docs/providers/azurerm/r/network_watcher_flow_log.html)
* [Private DNS Zone](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)

## Module Usage

```terraform
# Azurerm provider configuration
provider "azurerm" {
  features {}
}

```

## Hub Networking

Hub Networking is set up in a Management Hub design based on the SCCA Hub/Spoke architecture. The Management hub is a central point of connectivity to many different networks.

The Management hub contains the following resources:

* Virtual Network
* Subnets
* Subnet Service Delegation
* Virtual Network service endpoints
* Private Link service/Endpoint network policies on Subnet
* Azure Network DDoS Protection Plan
* Private DNS Zones
* Network Security Groups
* Azure Firewall
* Azure Firewall Application Rule Collection
* Azure Firewall Network Rule Collection

The following parameters affect Management Hub Networking.

Parameter name | Location | Default Value | Description
-------------- | ------------- | ------------- | -----------
`virtual_network_address_space` | `variables.vnet.tf` | '10.0.100.0/24' | The CIDR Virtual Network Address Prefix for the Hub Virtual Network.
`subnet_address_prefix` | `variables.snet.tf` | '10.0.100.128/27' | The CIDR Subnet Address Prefix for the default Hub subnet. It must be in the Hub Virtual Network space.
`firewall_client_snet_address_prefix` | `variables.fw.tf` | '10.0.100.0/26' | The CIDR Subnet Address Prefix for the Azure Firewall Subnet. It must be in the Hub Virtual Network space. It must be /26.
`firewall_management_snet_address_prefix` | `variables.fw.tf` | '10.0.100.64/26' | The CIDR Subnet Address Prefix for the Azure Firewall Management Subnet. It must be in the Hub Virtual Network space. It must be /26.

## Subnets

This module handles the creation and a list of address spaces for subnets. This module uses `for_each` to create subnets and corresponding service endpoints, service delegation, and network security groups. This module associates the subnets to network security groups as well with additional user-defined NSG rules.  

This module creates 4 subnets by default: Gateway Subnet, AzureFirewallSubnet, ApplicationGateway Subnet and Management Subnet.

Name | Description
---- | -----------
GatewaySubnet| Contain VPN Gateway, Express route Gateway
AzureFirewallSubnet|If added the Firewall module, it Deploys an Azure Firewall that will monitor all incoming and outgoing traffic
AzureFirewallManagementSubnet|
ApplicationGateway|This subnet contain an Application Gateway and any other DMZ services
Management|Management subnet for Bastion host, accessible from gateway

Both Gateway Subnet and AzureFirewallSubnet allow traffic out and can have public IPs. ApplicationGateway and Management subnet route traffic through the firewall and does not support public IPs due to asymmetric routing.

## Virtual Network service endpoints

Service Endpoints allows connecting certain platform services into virtual networks.  With this option, Azure virtual machines can interact with Azure SQL and Azure Storage accounts, as if they’re part of the same virtual network, rather than Azure virtual machines accessing them over the public endpoint.

This module supports enabling the service endpoint of your choosing under the virtual network and with the specified subnet. The list of Service endpoints to associate with the subnet values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.

```hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"

      service_endpoints     = ["Microsoft.Storage"]  
    }
  }

# ....omitted

}
```

## Subnet Service Delegation

Subnet delegation enables you to designate a specific subnet for an Azure PaaS service of your choice that needs to be injected into your virtual network. The Subnet delegation provides full control to manage the integration of Azure services into virtual networks.

This module supports enabling the service delegation of your choosing under the virtual network and with the specified subnet.  For more information, check the [terraform resource documentation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_delegation).

```hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"

      delegation = {
        name = "demodelegationcg"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }
  }

# ....omitted

}
```

## `private_endpoint_network_policies_enabled` - Private Link Endpoint on the subnet

Network policies, like network security groups (NSG), are not supported for Private Link Endpoints. In order to deploy a Private Link Endpoint on a given subnet, you must set the `private_endpoint_network_policies_enabled` attribute to `true`. This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link endpoint on the subnet. The default value is `false`. If you are enabling the Private Link Endpoints on the subnet you shouldn't use Private Link Services as it's conflicts.

```hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"
      private_endpoint_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted
  
  } 
```

## `private_link_service_network_policies_enabled` - private link service on the subnet

In order to deploy a Private Link Service on a given subnet, you must set the `private_link_service_network_policies_enabled` attribute to `true`. This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link service on the subnet. The default value is `false`. If you are enabling the Private Link service on the subnet then, you shouldn't use Private Link endpoints as it's conflicts.

```hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"
      private_link_service_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted

}
```

## Firewall

Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability.

![firewall-threat](https://docs.microsoft.com/en-us/azure/firewall/media/overview/firewall-threat.png)

Source: [Azure Firewall Documentation](https://docs.microsoft.com/en-us/azure/firewall/overview)

You can centrally create, enforce, and log application and network connectivity policies across subscriptions and virtual networks. Azure Firewall uses a static public IP address for your virtual network resources allowing outside firewalls to identify traffic originating from your virtual network. The service is fully integrated with Azure Monitor for logging and analytics.

This is designed to support hub and spoke architecture in the azure and further security hardening would be recommend to add appropriate firewall application/network/NAT rules to use this for any production workloads.

All network traffic is directed through the firewall residing in the Management Hub Network resource group. The firewall is configured as the default route for all other spokes including T0 (Identity and Authorization), T1 (Operations), T2 (Shared Services) Management Spokes and T3 (workload/team environments) workload spoke as follows:

|Name         |Address prefix| Next hop type| Next hop IP address|
|-------------|--------------|-----------------|-----------------|
|default_route| 0.0.0.0/0    |Virtual Appliance|10.0.100.4*       |

*-example IP for firewall

The default firewall configured for Management Hub Network is [Azure Firewall Premium](https://docs.microsoft.com/en-us/azure/firewall/premium-features).

>### Firewall Availability Zones

Azure Firewall can be configured during deployment to span multiple Availability Zones for increased availability. With Availability Zones, your availability increases to 99.99% uptime.  

To specifies the availability zones in which the Azure Firewall should be created, set the argument `firewall_zones = [1, 2, 3]`.  This is by default is not enabled and set to `none`. There's no additional cost for a firewall deployed in an Availability Zone. However, there are additional costs for inbound and outbound data transfers associated with Availability Zones.

>Note: Availability Zones can only be configured during deployment. You can't modify an existing firewall to include Availability Zones

>### Firewall Rules

This module centrally create allow or deny network filtering rules by source and destination IP address, port, and protocol. Azure Firewall is fully stateful, so it can distinguish legitimate packets for different types of connections. Rules are enforced and logged across multiple subscriptions and virtual networks.

To define the firewall rules, use the input variables `firewall_application_rules`, `firewall_network_rules` and `firewall_nat_rules`.

Presently, there are two firewall rules configured to ensure access to the Azure Portal and to facilitate interactive logon via PowerShell and Azure CLI, all other traffic is restricted by default. Below are the collection of rules configured for Azure Commercial and Azure Government clouds:

|Rule Collection Priority | Rule Collection Name | Rule name | Source | Port     | Protocol                               |
|-------------------------|----------------------|-----------|--------|----------|----------------------------------------|
|100                      | AllowAzureCloud      | AzureCloud|*       |   *      |Any                                     |
|110                      | AzureAuth            | msftauth  |  *     | Https:443| aadcdn.msftauth.net, aadcdn.msauth.net |

``` hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

# ....omitted

  # (Optional) specify the application rules for Azure Firewall
  firewall_application_rules = [
    {
      name             = "microsoft"
      action           = "Allow"
      source_addresses = ["10.0.0.0/8"]
      target_fqdns     = ["*.microsoft.com"]
      protocol = {
        type = "Http"
        port = "80"
      }
    },
  ]

  # (Optional) specify the Network rules for Azure Firewall
  firewall_network_rules = [
    {
      name                  = "ntp"
      action                = "Allow"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    },
  ]

  # (Optional) specify the NAT rules for Azure Firewall
  # Destination address must be Firewall public IP
  # `fw-public` is a variable value and automatically pick the firewall public IP from module.
  firewall_nat_rules = [
    {
      name                  = "testrule"
      action                = "Dnat"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["53", ]
      destination_addresses = ["fw-public"]
      translated_port       = 53
      translated_address    = "8.8.8.8"
      protocols             = ["TCP", "UDP", ]
    },
  ]

# ....omitted
}
```

## Network Security Groups

By default, the network security groups connected to Management and ApplicationGateway subnets will only allow necessary traffic and block everything else (deny-all rule). Use `nsg_subnet_inbound_rules` and `nsg_subnet_outbound_rules` in this Terraform module to create a Network Security Group (NSG) for each subnet and allow it to add additional rules for inbound flows.

In the Source and Destination columns, `VirtualNetwork`, `AzureLoadBalancer`, and `Internet` are service tags, rather than IP addresses. In the protocol column, Any encompasses `TCP`, `UDP`, and `ICMP`. When creating a rule, you can specify `TCP`, `UDP`, `ICMP` or `*`. `0.0.0.0/0` in the Source and Destination columns represents all addresses.

*You cannot remove the default rules, but you can override them by creating rules with higher priorities.*

```hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"
      nsg_subnet_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["weballow", "200", "Inbound", "Allow", "Tcp", "22", "*", ""],
        ["weballow1", "201", "Inbound", "Allow", "Tcp", "3389", "*", ""],
      ]

      nsg_subnet_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }
  }

# ....omitted

}
```

## Network Security Groups Rules

There are NSG rules that can be applied to the subnets. These rules are applied to the subnets by default. The rules are as follows:

|Rule Collection Priority | Rule Collection Name | Rule name | Source | Port     | Protocol                               |
|-------------------------|----------------------|-----------|--------|----------|----------------------------------------|
|100                      | AllowAzureCloud      | AzureCloud|*       |   *      |Any                                     |

## Peering

To peer spoke networks to the hub networks requires the service principal that performs the peering has `Network Contributor` role on hub network. Linking the Spoke to Hub DNS zones, the service principal also needs the `Private DNS Zone Contributor` role on hub network.

## Optional Features

Management Hub has optional features that can be enabled by setting parameters on the deployment.

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `resource_group_name` located in `variables.naming.tf`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Azure Network DDoS Protection Plan

By default, this module will not create a DDoS Protection Plan. You can enable/disable it by appending an argument `create_ddos_plan` located in `variables.vnet.tf`. If you want to enable a DDoS plan using this module, set argument `create_ddos_plan = true`

## Azure Network Network Watcher

This module handle the provision of Network Watcher resource by defining `create_network_watcher` variable. It will enable network watcher, flow logs and traffic analytics for all the subnets in the Virtual Network. Since Azure uses a specific naming standard on network watchers, It will create a resource group `NetworkWatcherRG` and adds the location specific resource.

> **Note:** Log Analytics workspace is required for NSG Flow Logs and Traffic Analytics. If you want to enable NSG Flow Logs and Traffic Analytics, you must create a Log Analytics workspace and provide the workspace name set argument `log_analytics_workspace_name` and rg set argument `log_analytics_workspace_resource_group_name`

## Enable Force Tunneling for the Firewall

By default, this module will not create a force tunnel on the firewall. You can enable/disable it by appending an argument `enable_force_tunneling` located in `variables.fw.tf` If you want to enable a DDoS plan using this module, set argument `enable_force_tunneling = true`. Enabling this feature will ensure that the firewall is the default route for all the T0 through T3 Network routes.

## Private DNS Zones for Azure PasS Services

This module facilitates the private DNS zone for the virtual network.  To create a zone, set the domain name for the private DNS zone with variable `private_dns_zone_name`. This will additionally link the virtual network hub to the private DNS zone.  It will assign all principals that have peering access as contributors so, spokes can remain linked to the same zone.

## Remote access with a Bastion Host

If you want to remotely access the network and the resources you've deployed you can use [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/) to remotely access virtual machines within the network without exposing them via Public IP Addresses.

By default, this module will not create a Azure Bastion Host. You can enable/disable it by appending an argument `enable_bastion_host` located in `variables.bastion.tf` If you want to enable a Azure Bastion Host using this module, set argument `enable_bastion_host = true`.

## Azure Firewall Premium

By default, Management Hub deploys **[Azure Firewall Premium](https://docs.microsoft.com/en-us/azure/firewall/premium-features). Not all regions support Azure Firewall Premium.** Check here to [see if the region you're deploying to supports Azure Firewall Premium](https://docs.microsoft.com/en-us/azure/firewall/premium-features#supported-regions). If necessary you can set a different firewall SKU or location.

You can manually specify which SKU of Azure Firewall to use for your deployment by specifying the `firewallSkuTier` parameter. This parameter only accepts values of `Standard` or `Premium`.

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`firewallSkuTier` | 'Premium' | [Standard/Premium] The SKU for Azure Firewall. It defaults to "Premium".

If you'd like to specify a different region to deploy your resources into, change the location of the deployment. For example, when using the AZ CLI set the deployment command's `--location` argument.

## `use_location_short_name` - use the shorten location name on resource names

By default, Management Hub uses the shorten location name for naming resources. For example, `eus2` is used instead of `eastus2`. You can enable/disable it by appending an argument `use_location_short_name` located in `variables.tf` If you want to disable shorten location name using this module, set argument `use_location_short_name = false`.

## Recommended naming and tagging conventions

Using tags to properly organize your Azure resources, resource groups, and subscriptions into a taxonomy. Each tag is made up of a name and a value pair. For example, you can apply the term `Environment` and the value `Production` to all production resources.
See Resource name and tagging choice guide for advice on how to apply a tagging strategy.

>**Important** :
For operations, tag names are case-insensitive. A tag with a tag name is updated or retrieved, independent of casing. The resource provider, on the other hand, may preserve the casing you supply for the tag name. Cost reports will show that casing. **The case of tag values is important.**

An effective naming convention creates resource names by incorporating vital resource information into the name. A public IP resource for a production SharePoint workload, for example, is named `pip-sharepoint-prod-westus-001` using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Other resources

* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)
