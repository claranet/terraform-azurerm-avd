resource "azurerm_virtual_desktop_workspace" "workspace" {
  name = local.avd_workspace_name

  location            = var.location
  resource_group_name = var.resource_group_name

  friendly_name = local.avd_workspace.friendly_name
  description   = local.avd_workspace.description

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_virtual_desktop_host_pool" "host_pool" {
  name = local.avd_hostpool_name

  location            = var.location
  resource_group_name = var.resource_group_name

  friendly_name = coalesce(var.hostpool_config.friendly_name, local.avd_hostpool_name)
  description   = var.hostpool_config.description

  validate_environment  = var.hostpool_config.validate_environment
  custom_rdp_properties = var.hostpool_config.custom_rdp_properties

  type                     = var.hostpool_config.type
  maximum_sessions_allowed = var.hostpool_config.maximum_sessions_allowed
  load_balancer_type       = var.hostpool_config.load_balancer_type # [BreadthFirst DepthFirst]
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registration_info" {
  count = var.hostpool_config.host_registration_enabled ? 1 : 0

  hostpool_id     = azurerm_virtual_desktop_host_pool.host_pool.id
  expiration_date = var.hostpool_config.registration_expiration_date
}

resource "azurerm_virtual_desktop_application_group" "app_group" {
  location            = var.location
  resource_group_name = var.resource_group_name

  host_pool_id = azurerm_virtual_desktop_host_pool.host_pool.id
  name         = local.avd_app_group_name

  friendly_name = var.application_group_config.friendly_name
  description   = var.application_group_config.description
  type          = var.application_group_config.type

  depends_on = [azurerm_virtual_desktop_host_pool.host_pool, azurerm_virtual_desktop_workspace.workspace]
}

# Associate Workspace and Application Group
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws_appgroup" {
  application_group_id = azurerm_virtual_desktop_application_group.app_group.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}
