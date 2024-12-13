resource "azurerm_role_definition" "scaling_role_definition" {
  count = local.scaling_plan_role_assignment_enabled ? 1 : 0

  name        = local.scaling_plan_role_definition.name
  description = local.scaling_plan_role_definition.description

  scope = local.resource_group_id

  permissions {
    actions = local.scaling_plan_role_definition.allowed_actions
  }
}

resource "azurerm_role_assignment" "scaling_role_assignment" {
  count = local.scaling_plan_role_assignment_enabled ? 1 : 0

  scope              = local.resource_group_id
  principal_id       = local.avd_service_principal_object_id
  role_definition_id = one(azurerm_role_definition.scaling_role_definition[*].role_definition_resource_id)

  skip_service_principal_aad_check = true
}

resource "azurerm_virtual_desktop_scaling_plan" "main" {
  count = var.scaling_plan_config.enabled ? 1 : 0

  name     = local.avd_scaling_plan_name
  location = var.location

  resource_group_name = var.resource_group_name

  friendly_name = coalesce(var.scaling_plan_config.friendly_name, local.avd_scaling_plan_name)
  description   = var.scaling_plan_config.description

  exclusion_tag = var.scaling_plan_config.exclusion_tag
  time_zone     = var.scaling_plan_config.timezone

  host_pool {
    hostpool_id          = azurerm_virtual_desktop_host_pool.main.id
    scaling_plan_enabled = var.scaling_plan_config.enabled
  }

  dynamic "schedule" {
    for_each = var.scaling_plan_config.schedules
    content {
      name                                 = schedule.value.name
      days_of_week                         = schedule.value.days_of_week
      off_peak_start_time                  = schedule.value.off_peak_start_time
      off_peak_load_balancing_algorithm    = schedule.value.off_peak_load_balancing_algorithm
      peak_start_time                      = schedule.value.peak_start_time
      peak_load_balancing_algorithm        = schedule.value.peak_load_balancing_algorithm
      ramp_down_start_time                 = schedule.value.ramp_down_start_time
      ramp_down_capacity_threshold_percent = schedule.value.ramp_down_capacity_threshold_percent
      ramp_down_force_logoff_users         = schedule.value.ramp_down_force_logoff_users
      ramp_down_load_balancing_algorithm   = schedule.value.ramp_down_load_balancing_algorithm
      ramp_down_minimum_hosts_percent      = schedule.value.ramp_down_minimum_hosts_percent
      ramp_down_notification_message       = schedule.value.ramp_down_notification_message
      ramp_down_stop_hosts_when            = schedule.value.ramp_down_stop_hosts_when
      ramp_down_wait_time_minutes          = schedule.value.ramp_down_wait_time_minutes
      ramp_up_start_time                   = schedule.value.ramp_up_start_time
      ramp_up_load_balancing_algorithm     = schedule.value.ramp_up_load_balancing_algorithm
      ramp_up_capacity_threshold_percent   = schedule.value.ramp_up_capacity_threshold_percent
      ramp_up_minimum_hosts_percent        = schedule.value.ramp_up_minimum_hosts_percent
    }
  }

  tags = merge(local.default_tags, var.scaling_plan_config.extra_tags, var.extra_tags)

  depends_on = [
    azurerm_role_assignment.scaling_role_assignment,
  ]
}

moved {
  from = azurerm_virtual_desktop_scaling_plan.scaling_plan
  to   = azurerm_virtual_desktop_scaling_plan.main
}
