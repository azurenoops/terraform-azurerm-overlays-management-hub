# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Route Table Configuration    ##
#################################

variable "enable_encrypted_transport" {
  description = "Whether to enable encrypted transport"
  default     = false
}

variable "encrypted_transport_address_prefix" {
  description = "The address prefix to use for the encrypted transport route table"
  default     = null
}

variable "encrypted_transport_next_hop_type" {
  description = "The next hop type to use for the encrypted transport route table"
  default     = null
}

variable "encrypted_transport_next_hop_in_ip_address" {
  description = "The next hop in IP address to use for the encrypted transport route table"
  default     = null
}
