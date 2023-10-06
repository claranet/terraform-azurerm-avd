locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  avd_workspace_name = coalesce(var.workspace_custom_name, data.azurecaf_name.avd_workspace.result)
  avd_hostpool_name  = coalesce(var.hostpool_custom_name, data.azurecaf_name.avd_hostpool.result)
  avd_app_group_name = coalesce(var.application_group_custom_name, data.azurecaf_name.avd_app_group.result)
}
