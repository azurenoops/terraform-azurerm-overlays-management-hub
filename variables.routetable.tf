# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Route Table Configuration    ##
#################################

variable "route_table_routes" {
  description = "A map of route table routes to add to the route table"
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = {}
}

variable "disable_bgp_route_propagation" {
  description = "Whether to disable the default BGP route propagation on the subnet"
  default     = false
}
