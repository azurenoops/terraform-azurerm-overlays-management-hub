# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "hub_storage_account_kind" {
  description = "The Kind of storage account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage. Default is StorageV2."
  type         = string
  default      = "StorageV2"
}

variable "hub_storage_account_tier" {
  description = "The Tier of storage account to create. Valid options are Standard and Premium. Default is Standard."
  type        = string
  default     = "Standard"
}

variable "hub_storage_account_replication_type" {
  description = "The Replication Type of storage account to create. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. Default is LRS."
  type        = string
  default     = "GRS"
}
