# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------

variable "private_dns_zones" {
  type        = list(string)
  description = "List of Private DNS Zones to create. Default is empty list."
  default     = []
}
