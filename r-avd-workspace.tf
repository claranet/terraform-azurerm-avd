resource "azurerm_virtual_desktop_workspace" "main" {
  name     = local.avd_workspace_name
  location = var.location

  resource_group_name = var.resource_group_name

  friendly_name = coalesce(var.workspace_config.friendly_name, local.avd_workspace_name)
  description   = coalesce(var.workspace_config.description, "${title(var.client_name)} Azure Virtual Desktop Workspace.")

  public_network_access_enabled = var.workspace_config.public_network_access_enabled

  tags = merge(local.default_tags, var.workspace_config.extra_tags, var.extra_tags)
}

moved {
  from = azurerm_virtual_desktop_workspace.workspace
  to   = azurerm_virtual_desktop_workspace.main
}
