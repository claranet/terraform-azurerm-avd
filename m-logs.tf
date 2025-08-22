module "diagnostics_workspace" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.1.0"

  resource_id = azurerm_virtual_desktop_workspace.main.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.diagnostic_settings_custom_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_host_pool" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.1.0"

  resource_id = azurerm_virtual_desktop_host_pool.main.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.diagnostic_settings_custom_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_app_group" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.1.0"

  resource_id = azurerm_virtual_desktop_application_group.main.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.diagnostic_settings_custom_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}

module "diagnostics_scaling_plan" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.1.0"

  count = var.scaling_plan_config.enabled ? 1 : 0

  resource_id = one(azurerm_virtual_desktop_scaling_plan.main[*].id)

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  custom_name = var.diagnostic_settings_custom_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
}
