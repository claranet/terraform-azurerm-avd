data "azurerm_client_config" "current" {}

data "azuread_service_principal" "avd_service_principal" {
  count = (
    var.scaling_plan_config.enabled && var.scaling_plan_config.role_assignment.enabled && var.scaling_plan_config.role_assignment.principal_id == null
  ) ? 1 : 0

  client_id = local.avd_service_principal_client_id
}
