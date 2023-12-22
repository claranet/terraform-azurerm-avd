# Refactoring - 12/2023
moved {
  from = azurerm_virtual_desktop_workspace_application_group_association.ws_appgroup
  to   = azurerm_virtual_desktop_workspace_application_group_association.workspace_app_group_association
}

moved {
  from = module.diagnostics_hostpool
  to   = module.diagnostics_host_pool
}
