resource "azurerm_virtual_desktop_application_group" "app_group" {
  name     = local.avd_app_group_name
  location = var.location

  resource_group_name = var.resource_group_name

  host_pool_id = azurerm_virtual_desktop_host_pool.host_pool.id

  friendly_name                = coalesce(var.application_group_config.friendly_name, local.avd_app_group_name)
  default_desktop_display_name = var.application_group_config.type == "Desktop" ? var.application_group_config.default_desktop_display_name : null
  description                  = var.application_group_config.description

  type = var.application_group_config.type

  tags = merge(local.default_tags, var.application_group_config.extra_tags, var.extra_tags)
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace_app_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.app_group.id
}
