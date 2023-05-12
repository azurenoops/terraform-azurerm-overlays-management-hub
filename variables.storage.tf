# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "storage_account_kind" {
  description = "The Kind of storage account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage"
  type         = string
  default      = "StorageV2"
}

variable "storage_account_tier" {
  description = "The Tier of storage account to create. Valid options are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "The Replication Type of storage account to create. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
  default     = "GRS"
}
