data "azurenoopsutils_resource_name" "private_endpoint" {
  resource_type = "azurerm_private_endpoint"

  name        = var.workload_name
  prefixes    = [var.org_name, var.location]
  suffixes    = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "pe"])
  use_slug    = var.use_naming
  clean_input = true
  separator   = "-"
}

data "azurenoopsutils_resource_name" "private_dns_zone_group" {
  resource_type = "azurerm_private_dns_zone_group"

  name        = var.workload_name
  prefixes    = [var.org_name, var.location]
  suffixes    = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "pdnszg"])
  use_slug    = var.use_naming
  clean_input = true
  separator   = "-"
}

data "azurenoopsutils_resource_name" "private_service_connection" {
  resource_type = "azurerm_private_service_connection"

  name        = var.workload_name
  prefixes    = [var.org_name, var.location]
  suffixes    = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "psc"])
  use_slug    = var.use_naming
  clean_input = true
  separator   = "-"
}
 
