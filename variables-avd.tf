variable "workspace_config" {
  description = "AVD Workspace specific configuration."
  type = object({
    friendly_name = optional(string)
    description   = optional(string)
  })
  default  = {}
  nullable = false
}

variable "hostpool_config" {
  description = "AVD Host Pool specific configuration."
  type = object({
    friendly_name            = optional(string)
    description              = optional(string)
    validate_environment     = optional(bool, true)
    custom_rdp_properties    = optional(string, "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;")
    type                     = optional(string, "Pooled")
    maximum_sessions_allowed = optional(number, 16)
    load_balancer_type       = optional(string, "DepthFirst")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["BreadthFirst", "DepthFirst"], var.hostpool_config.load_balancer_type)
    error_message = "`var.hostpool_config.load_balancer_type` must be 'BreadthFirst' or 'DepthFirst', got ${var.hostpool_config.load_balancer_type}."
  }
}

variable "application_group_config" {
  description = "AVD Application Group specific configuration."
  type = object({
    friendly_name = optional(string)
    description   = optional(string)
    type          = optional(string, "Desktop")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["Desktop", "RemoteApp"], var.application_group_config.type)
    error_message = "`var.application_group_config.type` must be 'Desktop' or 'RemoteApp', got ${var.application_group_config.type}."
  }
}
