# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################
# Tags Configuration    ##
####################################
variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "add_tags" {
  description = "Map of custom tags."
  type        = map(string)
  default     = {}
}
