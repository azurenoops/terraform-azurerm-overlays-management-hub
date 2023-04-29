# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################
# Firewall Configuration    ##
##############################

variable "enable_firewall" {
  description = "Controls if Azure Firewall resources should be created for the Azure subscription"
  default     = true
}

variable "enable_forced_tunneling" {
  description = "Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet"
  default     = true
}

variable "fw_client_snet_address_prefix" {
  description = "The address prefix to use for the Firewall subnet"
  default     = null
}

variable "fw_management_snet_address_prefix" {
  description = "The address prefix to use for Firewall managemement subnet to enable forced tunnelling. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a `/26`."
  default     = null
}

variable "fw_client_snet_service_endpoints" {
  description = "Service endpoints to add to the firewall client subnet"
  type        = list(string)
  default     = []
}

variable "fw_client_snet_private_endpoint_network_policies_enabled" {
  description = "Controls if network policies are enabled on the firewall client subnet"
  type        = bool
  default     = false
}

variable "fw_client_snet_private_link_service_network_policies_enabled" {
  description = "Controls if private link service network policies are enabled on the firewall client subnet"
  type        = bool
  default     = false
}

variable "fw_management_snet_service_endpoints" {
  description = "Service endpoints to add to the firewall management subnet"
  type        = list(string)
  default     = []
}

variable "fw_management_snet_private_endpoint_network_policies_enabled" {
  description = "Controls if network policies are enabled on the firewall management subnet"
  type        = bool
  default     = false
}

variable "fw_management_snet_private_link_service_network_policies_enabled" {
  description = "Controls if private link service network policies are enabled on the firewall management subnet"
  type        = bool
  default     = false
}

variable "fw_intrusion_detection_mode" {
  description = "Controls if Azure Firewall Intrusion Detection System (IDS) should be enabled for the Azure subscription"
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.fw_intrusion_detection_mode)
    error_message = "The Intrusion Detection Mode must be either 'Alert' or 'Deny' or 'Off'. The default value is 'Alert'."
  }
}

variable "fw_threat_intelligence_mode" {
  description = "Controls if Azure Firewall Threat Intelligence should be enabled for the Azure subscription"
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.fw_threat_intelligence_mode)
    error_message = "The Threat Intelligence Mode must be either 'Alert' or 'Deny' or 'Off'. The default value is 'Alert'."
  }
}

variable "base_policy_id" {
  description = "The ID of the base policy to use for the Azure Firewall. This is used to create a new policy based on the base policy."
  default     = null
}

variable "firewall_config" {
  description = "Manages an Azure Firewall configuration"
  type = object({
    sku_name          = optional(string)
    sku_tier          = optional(string)
    dns_servers       = optional(list(string))
    private_ip_ranges = optional(list(string))
    threat_intel_mode = optional(string)
    zones             = optional(list(string))
  })
}

variable "virtual_hub" {
  description = "An Azure Virtual WAN Hub with associated security and routing policies configured by Azure Firewall Manager. Use secured virtual hubs to easily create hub-and-spoke and transitive architectures with native security services for traffic governance and protection."
  type = object({
    virtual_hub_id  = string
    public_ip_count = number
  })
  default = null
}

variable "fw_application_rules" {
  description = "List of application rules to apply to firewall."
  type = list(object({
    name             = string
    description      = optional(string)
    action           = string
    source_addresses = optional(list(string))
    source_ip_groups = optional(list(string))
    fqdn_tags        = optional(list(string))
    target_fqdns     = optional(list(string))
    protocol = optional(object({
      type = string
      port = string
    }))
  }))
  default = []
}

variable "fw_network_rules" {
  description = "List of network rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = optional(list(string))
    destination_fqdns     = optional(list(string))
    protocols             = list(string)
  }))
  default = []
}

variable "fw_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = list(string)
    protocols             = list(string)
    translated_address    = string
    translated_port       = string
  }))
  default = []
}


##################################
# Firewall PIP Configuration    ##
##################################

variable "fw_pip_sku" {
  description = "The SKU of the public IP address"
  type        = string
  default     = "Standard"
}

variable "fw_pip_allocation_method" {
  description = "The allocation method of the public IP address"
  type        = string
  default     = "Static"
}
