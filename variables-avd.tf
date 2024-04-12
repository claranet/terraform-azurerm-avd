variable "workspace_config" {
  description = "AVD Workspace specific configuration."
  type = object({
    friendly_name                 = optional(string)
    description                   = optional(string)
    public_network_access_enabled = optional(bool)
    extra_tags                    = optional(map(string))
  })
  default  = {}
  nullable = false
}

variable "host_pool_config" {
  description = "AVD Host Pool specific configuration."
  type = object({
    friendly_name                         = optional(string)
    description                           = optional(string)
    validate_environment                  = optional(bool, true)
    custom_rdp_properties                 = optional(string, "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;")
    type                                  = optional(string, "Pooled")
    load_balancer_type                    = optional(string, "BreadthFirst")
    personal_desktop_assignment_type      = optional(string, "Automatic")
    maximum_sessions_allowed              = optional(number, 16)
    preferred_app_group_type              = optional(string)
    start_vm_on_connect                   = optional(bool, false)
    host_registration_expires_in_in_hours = optional(number, 48)
    scheduled_agent_updates = optional(object({
      enabled                   = optional(bool, false)
      timezone                  = optional(string, "UTC") # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
      use_session_host_timezone = optional(bool, false)
      schedules = optional(list(object({
        day_of_week = string
        hour_of_day = number
      })), [])
    }), {})
    extra_tags = optional(map(string))
  })
  default  = {}
  nullable = false

  validation {
    condition     = var.host_pool_config.host_registration_expires_in_in_hours >= 2
    error_message = "`var.host_pool_config.host_registration_expires_in_in_hours` must be at least two hour from now."
  }
  validation {
    condition     = var.host_pool_config.host_registration_expires_in_in_hours <= 720
    error_message = "`var.host_pool_config.host_registration_expires_in_in_hours` must be no more than 720 hours (30 days) from now."
  }
  validation {
    condition     = var.host_pool_config.scheduled_agent_updates.enabled ? length(var.host_pool_config.scheduled_agent_updates.schedules) == 1 || length(var.host_pool_config.scheduled_agent_updates.schedules) == 2 : true
    error_message = "When `var.host_pool_config.scheduled_agent_updates.enabled = true`, at least one and up to 2 maintenance windows can be defined, got ${length(var.host_pool_config.scheduled_agent_updates.schedules)}."
  }
}

variable "application_group_config" {
  description = "AVD Application Group specific configuration."
  type = object({
    friendly_name                = optional(string)
    default_desktop_display_name = optional(string)
    description                  = optional(string)
    type                         = optional(string, "Desktop")
    role_assignments_object_ids  = optional(list(string), [])
    extra_tags                   = optional(map(string))
  })
  default  = {}
  nullable = false
}

variable "scaling_plan_config" {
  description = "AVD Scaling Plan specific configuration."
  type = object({
    enabled       = optional(bool, false)
    friendly_name = optional(string)
    description   = optional(string)
    exclusion_tag = optional(string)
    timezone      = optional(string, "UTC") # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
    schedules = optional(list(object({
      name                                 = string
      days_of_week                         = list(string)
      peak_start_time                      = string
      peak_load_balancing_algorithm        = optional(string, "BreadthFirst")
      off_peak_start_time                  = string
      off_peak_load_balancing_algorithm    = optional(string, "DepthFirst")
      ramp_up_start_time                   = string
      ramp_up_load_balancing_algorithm     = optional(string, "BreadthFirst")
      ramp_up_capacity_threshold_percent   = optional(number, 75)
      ramp_up_minimum_hosts_percent        = optional(number, 33)
      ramp_down_start_time                 = string
      ramp_down_capacity_threshold_percent = optional(number, 5)
      ramp_down_force_logoff_users         = optional(string, false)
      ramp_down_load_balancing_algorithm   = optional(string, "DepthFirst")
      ramp_down_minimum_hosts_percent      = optional(number, 33)
      ramp_down_notification_message       = optional(string, "Please log off in the next 45 minutes...")
      ramp_down_stop_hosts_when            = optional(string, "ZeroSessions")
      ramp_down_wait_time_minutes          = optional(number, 45)
    })), [])
    role_assignment = optional(object({
      enabled   = optional(bool, true)
      object_id = optional(string)
    }), {})
    extra_tags = optional(map(string))
  })
  default  = {}
  nullable = false
}
