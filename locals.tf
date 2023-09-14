locals {
  avd_workspace = {
    friendly_name = coalesce(var.workspace_config.friendly_name, format("%s AVD Worskpace", var.client_name))
    description   = coalesce(var.workspace_config.description, format("%s AVD Worskpace", var.client_name))
  }
}
