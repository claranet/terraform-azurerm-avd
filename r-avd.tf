resource "azurerm_virtual_desktop_workspace" "avd" {
  name = local.avd_name

  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(local.default_tags, var.extra_tags)
}
