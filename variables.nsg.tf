# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#############################
# NSG Rules Configuration  ##
#############################

variable "http_inbound_allowed" {
  description = "True to allow inbound HTTP traffic"
  type        = bool
  default     = false
}

variable "allowed_http_source" {
  description = "Allowed source for inbound HTTP traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_http_source != null &&
      var.allowed_http_source != "" &&
      (can(tolist(var.allowed_http_source)) || can(tostring(var.allowed_http_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "https_inbound_allowed" {
  description = "True to allow inbound HTTPS traffic"
  type        = bool
  default     = false
}

variable "allowed_https_source" {
  description = "Allowed source for inbound HTTPS traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_https_source != null &&
      var.allowed_https_source != "" &&
      (can(tolist(var.allowed_https_source)) || can(tostring(var.allowed_https_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "ssh_inbound_allowed" {
  description = "True to allow inbound SSH traffic"
  type        = bool
  default     = false
}

variable "allowed_ssh_source" {
  description = "Allowed source for inbound SSH traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_ssh_source != null &&
      var.allowed_ssh_source != "" &&
      (can(tolist(var.allowed_ssh_source)) || can(tostring(var.allowed_ssh_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "rdp_inbound_allowed" {
  description = "True to allow inbound RDP traffic"
  type        = bool
  default     = false
}

variable "allowed_rdp_source" {
  description = "Allowed source for inbound RDP traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_rdp_source != null &&
      var.allowed_rdp_source != "" &&
      (can(tolist(var.allowed_rdp_source)) || can(tostring(var.allowed_rdp_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "winrm_inbound_allowed" {
  description = "True to allow inbound WinRM traffic"
  type        = bool
  default     = false
}

variable "allowed_winrm_source" {
  description = "Allowed source for inbound WinRM traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_winrm_source != null &&
      var.allowed_winrm_source != "" &&
      (can(tolist(var.allowed_winrm_source)) || can(tostring(var.allowed_winrm_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "application_gateway_rules_enabled" {
  description = "True to configure rules mandatory for hosting an Application Gateway. See https://docs.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#allow-access-to-a-few-source-ips"
  type        = bool
  default     = false
}

variable "load_balancer_rules_enabled" {
  description = "True to configure rules mandatory for hosting a Load Balancer."
  type        = bool
  default     = false
}

variable "nsg_additional_rules" {
  description = "Additional network security group rules to add. For arguments please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference"
  type = map(object(
    {
      nsg_rule_priority                   = number # (Required) NSG rule priority.
      nsg_rule_direction                  = string # (Required) NSG rule direction. Possible values are `Inbound` and `Outbound`.
      nsg_rule_access                     = string # (Required) NSG rule access. Possible values are `Allow` and `Deny`.
      nsg_rule_protocol                   = string # (Required) NSG rule protocol. Possible values are `Tcp`, `Udp`, `Icmp`, `Esp`, `Asterisk`.
      nsg_rule_source_port_range          = string # (Required) NSG rule source port range.
      nsg_rule_destination_port_range     = string # (Required) NSG rule destination port range.
      nsg_rule_source_address_prefix      = string # (Required) NSG rule source address prefix.
      nsg_rule_destination_address_prefix = string # (Required) NSG rule destination address prefix.
    }
  ))
  default = {}
}

variable "nfs_inbound_allowed" {
  description = "True to allow inbound NFSv4 traffic"
  type        = bool
  default     = false
}

variable "allowed_nfs_source" {
  description = "Allowed source for inbound NFSv4 traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_nfs_source != null &&
      var.allowed_nfs_source != "" &&
      (can(tolist(var.allowed_nfs_source)) || can(tostring(var.allowed_nfs_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}

variable "cifs_inbound_allowed" {
  description = "True to allow inbound CIFS traffic"
  type        = bool
  default     = false
}

variable "allowed_cifs_source" {
  description = "Allowed source for inbound CIFS traffic. Can be a Service Tag, \"*\" or a CIDR list."
  type        = any
  default     = []
  validation {
    condition = (
      var.allowed_cifs_source != null &&
      var.allowed_cifs_source != "" &&
      (can(tolist(var.allowed_cifs_source)) || can(tostring(var.allowed_cifs_source)))
    )
    error_message = "Variable must be a Service Tag, \"*\" or a list of CIDR."
  }
}
