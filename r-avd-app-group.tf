resource "azurerm_virtual_desktop_application_group" "main" {
  name     = local.avd_app_group_name
  location = var.location

  resource_group_name = var.resource_group_name

  host_pool_id = azurerm_virtual_desktop_host_pool.main.id

  friendly_name                = coalesce(var.application_group_config.friendly_name, local.avd_app_group_name)
  default_desktop_display_name = var.application_group_config.type == "Desktop" ? var.application_group_config.default_desktop_display_name : null
  description                  = var.application_group_config.description

  type = var.application_group_config.type

  tags = merge(local.default_tags, var.application_group_config.extra_tags, var.extra_tags)
}

moved {
  from = azurerm_virtual_desktop_application_group.app_group
  to   = azurerm_virtual_desktop_application_group.main
}

resource "azurerm_role_assignment" "app_group_role_assignments" {
  for_each = toset(var.application_group_config.role_assignments_object_ids)

  scope                = azurerm_virtual_desktop_application_group.main.id
  principal_id         = each.key
  role_definition_name = "Desktop Virtualization User"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "main" {
  workspace_id         = azurerm_virtual_desktop_workspace.main.id
  application_group_id = azurerm_virtual_desktop_application_group.main.id
}

moved {
  from = azurerm_virtual_desktop_workspace_application_group_association.workspace_app_group_association
  to   = azurerm_virtual_desktop_workspace_application_group_association.main
}
