resource "azurerm_virtual_desktop_application" "main" {
  for_each = var.applications_config

  name                 = coalesce(each.value.custom_name, format("%s-%s", data.azurecaf_name.avd_app.result, each.key))
  application_group_id = azurerm_virtual_desktop_application_group.main.id

  friendly_name                = each.value.friendly_name
  description                  = each.value.description
  path                         = each.value.path
  command_line_argument_policy = each.value.command_line_argument_policy
  command_line_arguments       = each.value.command_line_arguments
  show_in_portal               = each.value.show_in_portal
  icon_path                    = each.value.icon_path
  icon_index                   = each.value.icon_index
}

moved {
  from = azurerm_virtual_desktop_application.app
  to   = azurerm_virtual_desktop_application.main
}
