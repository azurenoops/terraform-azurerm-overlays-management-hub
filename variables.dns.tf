# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------

variable "enable_private_dns_zones" {
  type        = bool
  description = "If set to true, will enable the deployment of Private DNS Zones. Default is true."
  default     = true  
}

variable "private_dns_zones" {
  type        = list(string)
  description = "List of Private DNS Zones to create. Default is empty list."
  default     = []
}
