# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------

variable "enable_default_private_dns_zones" {
  type = bool
  default = false
  description = "Enable default Private DNS Zones. Default is false."
}

variable "private_dns_zones" {
  type = list(string)
  description = "List of Private DNS Zones to create. Default is empty list."
  default = []
}
