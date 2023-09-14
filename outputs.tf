output "avd" {
  description = "Azure Virtual Desktop output object"
  value       = azurerm_virtual_desktop_workspace.avd
}

output "id" {
  description = "Azure Virtual Desktop ID"
  value       = azurerm_virtual_desktop_workspace.avd.id
}

output "name" {
  description = "Azure Virtual Desktop name"
  value       = azurerm_virtual_desktop_workspace.avd.name
}

output "identity_principal_id" {
  description = "Azure Virtual Desktop system identity principal ID"
  value       = try(azurerm_virtual_desktop_workspace.avd.identity[0].principal_id, null)
}
