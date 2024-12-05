# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
data "azurecaf_name" "avd_workspace" {
  name          = var.stack
  resource_type = "azurerm_virtual_desktop_workspace"
  prefixes      = var.name_prefix == "" ? ["vdws"] : [local.name_prefix, "vdws"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "avd_host_pool" {
  name          = var.stack
  resource_type = "azurerm_virtual_desktop_host_pool"
  prefixes      = var.name_prefix == "" ? ["vdpool"] : [local.name_prefix, "vdpool"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "avd_app_group" {
  name          = var.stack
  resource_type = "azurerm_virtual_desktop_application_group"
  prefixes      = var.name_prefix == "" ? ["vdag"] : [local.name_prefix, "vdag"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "avd_scaling_plan" {
  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = var.name_prefix == "" ? ["vdscaling"] : [local.name_prefix, "vdscaling"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "avd_app" {
  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = var.name_prefix == "" ? ["vda"] : [local.name_prefix, "vda"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}
