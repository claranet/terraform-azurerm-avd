output "resource_workspace" {
  description = "AVD Workspace resource object."
  value       = azurerm_virtual_desktop_workspace.main
}

output "workspace_id" {
  description = "AVD Workspace ID."
  value       = azurerm_virtual_desktop_workspace.main.id
}

output "workspace_name" {
  description = "AVD Workspace name."
  value       = azurerm_virtual_desktop_workspace.main.name
}

output "resource_host_pool" {
  description = "AVD Host Pool resource object."
  value       = azurerm_virtual_desktop_host_pool.main
}

output "host_pool_id" {
  description = "AVD Host Pool ID."
  value       = azurerm_virtual_desktop_host_pool.main.id
}

output "host_pool_name" {
  description = "AVD Host Pool name."
  value       = azurerm_virtual_desktop_host_pool.main.name
}

output "host_registration_token" {
  description = "AVD host registration token."
  value       = azurerm_virtual_desktop_host_pool_registration_info.main.token
  sensitive   = true
}

output "host_registration_token_expiration_date" {
  description = "AVD host registration token expiration date."
  value       = azurerm_virtual_desktop_host_pool_registration_info.main.expiration_date
}

output "resource_application_group" {
  description = "AVD Application Group resource object."
  value       = azurerm_virtual_desktop_application_group.main
}

output "application_group_id" {
  description = "AVD Application Group ID."
  value       = azurerm_virtual_desktop_application_group.main.id
}

output "application_group_name" {
  description = "AVD Application Group name."
  value       = azurerm_virtual_desktop_application_group.main.name
}

output "resource_scaling_plan" {
  description = "AVD Scaling Plan resource object."
  value       = one(azurerm_virtual_desktop_scaling_plan.main[*])
}

output "scaling_plan_id" {
  description = "AVD Scaling Plan ID."
  value       = one(azurerm_virtual_desktop_scaling_plan.main[*].id)
}

output "scaling_plan_name" {
  description = "AVD Scaling Plan name."
  value       = one(azurerm_virtual_desktop_scaling_plan.main[*].name)
}

output "scaling_plan_role_definition" {
  description = "AVD Scaling Plan Role Definition resource object."
  value       = one(azurerm_role_definition.scaling_role_definition[*])
}

output "scaling_plan_role_definition_id" {
  description = "AVD Scaling Plan Role Definition ID."
  value       = one(azurerm_role_definition.scaling_role_definition[*].id)
}

output "scaling_plan_role_definition_name" {
  description = "AVD Scaling Plan Role Definition name."
  value       = one(azurerm_role_definition.scaling_role_definition[*].name)
}

output "avd_service_principal_client_id" {
  description = "AVD Service Principal Client ID (Application ID)."
  value       = data.azuread_application_published_app_ids.well_known.result["WindowsVirtualDesktop"]
}

output "avd_service_principal_object_id" {
  description = "AVD Service Principal Object ID (Principal ID)."
  value       = local.avd_service_principal_object_id
}

output "avd_service_principal_name" {
  description = "AVD Service Principal name."
  value       = one(data.azuread_service_principal.avd_service_principal[*].display_name)
}

output "resouce_application" {
  description = "AVD Application resource object."
  value       = one(azurerm_virtual_desktop_application.main[*])
}
