data "azurerm_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

# https://learn.microsoft.com/en-us/azure/virtual-desktop/service-principal-assign-roles?tabs=portal
data "azuread_service_principal" "avd_service_principal" {
  count = (
    var.scaling_plan_config.enabled && var.scaling_plan_config.role_assignment.enabled && var.scaling_plan_config.role_assignment.object_id == null
  ) ? 1 : 0

  client_id = data.azuread_application_published_app_ids.well_known.result["WindowsVirtualDesktop"]
}
