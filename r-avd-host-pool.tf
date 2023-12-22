resource "azurerm_virtual_desktop_host_pool" "host_pool" {
  name     = local.avd_host_pool_name
  location = var.location

  resource_group_name = var.resource_group_name

  friendly_name = coalesce(var.host_pool_config.friendly_name, local.avd_host_pool_name)
  description   = var.host_pool_config.description

  validate_environment  = var.host_pool_config.validate_environment
  custom_rdp_properties = var.host_pool_config.custom_rdp_properties

  type                             = var.host_pool_config.type
  load_balancer_type               = var.host_pool_config.type == "Personal" ? "Persistent" : var.host_pool_config.load_balancer_type
  personal_desktop_assignment_type = var.host_pool_config.type == "Personal" ? var.host_pool_config.personal_desktop_assignment_type : null
  maximum_sessions_allowed         = var.host_pool_config.type == "Pooled" ? var.host_pool_config.maximum_sessions_allowed : null
  preferred_app_group_type         = coalesce(var.host_pool_config.preferred_app_group_type, var.application_group_config.type == "Desktop" ? "Desktop" : "RailApplications")
  start_vm_on_connect              = var.host_pool_config.start_vm_on_connect

  scheduled_agent_updates {
    enabled                   = var.host_pool_config.scheduled_agent_updates.enabled
    timezone                  = var.host_pool_config.scheduled_agent_updates.timezone
    use_session_host_timezone = var.host_pool_config.scheduled_agent_updates.use_session_host_timezone

    dynamic "schedule" {
      for_each = var.host_pool_config.scheduled_agent_updates.enabled ? var.host_pool_config.scheduled_agent_updates.schedules : []
      content {
        day_of_week = schedule.value.day_of_week
        hour_of_day = schedule.value.hour_of_day
      }
    }
  }

  tags = merge(local.default_tags, var.host_pool_config.extra_tags, var.extra_tags)
}

# `terraform/tfwrapper taint module.avd.time_rotating.time` to force recreation
resource "time_rotating" "time" {
  rotation_hours = var.host_pool_config.host_registration_expires_in_in_hours

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "host_pool_registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.host_pool.id
  expiration_date = time_rotating.time.rotation_rfc3339
}
