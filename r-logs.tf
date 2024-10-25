module "diagnostics_workspace" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.0.0"

  resource_id = azurerm_virtual_desktop_workspace.workspace.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.custom_diagnostic_settings_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_host_pool" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.0.0"

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
  version = "~> 8.0.0"

  resource_id = azurerm_virtual_desktop_application_group.app_group.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.custom_diagnostic_settings_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_scaling_plan" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.0.0"

  count = var.scaling_plan_config.enabled ? 1 : 0

  resource_id = one(azurerm_virtual_desktop_scaling_plan.scaling_plan[*].id)

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.custom_diagnostic_settings_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}
