# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}