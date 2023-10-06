module "diagnostics_workspace" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 6.5.0"

  resource_id = azurerm_virtual_desktop_workspace.workspace.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.custom_diagnostic_settings_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_hostpool" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 6.5.0"

  resource_id = azurerm_virtual_desktop_host_pool.host_pool.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.custom_diagnostic_settings_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_app_group" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 6.5.0"

  resource_id = azurerm_virtual_desktop_application_group.app_group.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.custom_diagnostic_settings_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}
