output "workspace" {
  description = "AVD Workspace output object."
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
  description = "AVD Host Pool output object."
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
  value       = one(azurerm_virtual_desktop_host_pool_registration_info.registration_info[*].token)
  sensitive   = true
}

output "host_registration_token_expiration_date" {
  description = "AVD host registration token expiration date."
  value       = one(azurerm_virtual_desktop_host_pool_registration_info.registration_info[*].expiration_date)
}
