output "workspace" {
  description = "AVD Workspace object output."
  value       = azurerm_virtual_desktop_workspace.workspace
}

output "workspace_id" {
  description = "AVD Workspace ID."
  value       = azurerm_virtual_desktop_workspace.workspace.id
}

output "workspace_name" {
  description = "AVD Workspace name."
  value       = azurerm_virtual_desktop_workspace.workspace.name
}

output "host_pool" {
  description = "AVD Host Pool object output."
  value       = azurerm_virtual_desktop_host_pool.host_pool
}

output "host_pool_id" {
  description = "AVD Host Pool ID."
  value       = azurerm_virtual_desktop_host_pool.host_pool.id
}

output "host_pool_name" {
  description = "AVD Host Pool name."
  value       = azurerm_virtual_desktop_host_pool.host_pool.name
}

output "host_registration_token" {
  description = "AVD host registration token."
  value       = azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration_info.token
  sensitive   = true
}

output "host_registration_token_expiration_date" {
  description = "AVD host registration token expiration date."
  value       = azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration_info.expiration_date
}

output "application_group" {
  description = "AVD Application Group object output."
  value       = azurerm_virtual_desktop_application_group.app_group
}

output "application_group_id" {
  description = "AVD Application Group ID."
  value       = azurerm_virtual_desktop_application_group.app_group.id
}

output "application_group_name" {
  description = "AVD Application Group name."
  value       = azurerm_virtual_desktop_application_group.app_group.name
}

output "scaling_plan" {
  description = "AVD Scaling Plan object output."
  value       = one(azurerm_virtual_desktop_scaling_plan.scaling_plan[*])
}

output "scaling_plan_id" {
  description = "AVD Scaling Plan ID."
  value       = one(azurerm_virtual_desktop_scaling_plan.scaling_plan[*].id)
}

output "scaling_plan_name" {
  description = "AVD Scaling Plan name."
  value       = one(azurerm_virtual_desktop_scaling_plan.scaling_plan[*].name)
}

output "scaling_plan_role_definition" {
  description = "AVD Scaling Plan Role Definition object output."
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
  value       = local.avd_service_principal_client_id
}

output "avd_service_principal_object_id" {
  description = "AVD Service Principal Object ID (Principal ID)."
  value       = local.avd_service_principal_object_id
}

output "avd_service_principal_name" {
  description = "AVD Service Principal name."
  value       = one(data.azuread_service_principal.avd_service_principal[*].display_name)
}
