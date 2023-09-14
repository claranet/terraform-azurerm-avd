output "workspace" {
  description = "Azure Virtual Desktop Workspace output object"
  value       = azurerm_virtual_desktop_workspace.workspace
}

output "workspace_id" {
  description = "Azure Virtual Desktop Workspace ID"
  value       = azurerm_virtual_desktop_workspace.workspace.id
}

output "workspace_name" {
  description = "Azure Virtual Desktop Workspace name"
  value       = azurerm_virtual_desktop_workspace.workspace.name
}

# output "identity_principal_id" {
#   description = "Azure Virtual Desktop system identity principal ID"
#   value       = try(azurerm_virtual_desktop_workspace.avd.identity[0].principal_id, null)
# }
