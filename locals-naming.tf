locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  avd_workspace_name    = coalesce(var.workspace_custom_name, data.azurecaf_name.avd_workspace.result)
  avd_host_pool_name    = coalesce(var.host_pool_custom_name, data.azurecaf_name.avd_host_pool.result)
  avd_app_group_name    = coalesce(var.application_group_custom_name, data.azurecaf_name.avd_app_group.result)
  avd_scaling_plan_name = coalesce(var.scaling_plan_custom_name, data.azurecaf_name.avd_scaling_plan.result)
}
