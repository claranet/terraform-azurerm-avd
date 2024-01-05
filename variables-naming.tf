# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "workspace_custom_name" {
  description = "Custom Azure Virtual Desktop workspace name, generated if not set."
  type        = string
  default     = ""
}

variable "host_pool_custom_name" {
  description = "Custom Azure Virtual Desktop host pool name, generated if not set."
  type        = string
  default     = ""
}

variable "application_group_custom_name" {
  description = "Custom Azure Virtual Desktop Application Group name, generated if not set."
  type        = string
  default     = ""
}

variable "scaling_plan_custom_name" {
  description = "Custom Azure Virtual Desktop Scaling Plan name, generated if not set."
  type        = string
  default     = ""
}
