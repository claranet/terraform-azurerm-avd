locals {
  resource_group_id = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_client_config.current.subscription_id, var.resource_group_name)
}
