locals {
  # https://learn.microsoft.com/en-us/azure/virtual-desktop/service-principal-assign-roles?tabs=portal
  avd_service_principal_client_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
  avd_service_principal_object_id = coalesce(var.scaling_plan_config.role_assignment.principal_id, one(data.azuread_service_principal.avd_service_principal[*].object_id))

  scaling_plan_role_assignment_enabled = var.scaling_plan_config.enabled && var.scaling_plan_config.role_assignment.enabled

  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan
  scaling_plan_role_definition = {
    name        = "AVD AutoScale"
    description = "AVD AutoScale Role."
    allowed_actions = [
      "Microsoft.Insights/eventtypes/values/read",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.DesktopVirtualization/hostpools/read",
      "Microsoft.DesktopVirtualization/hostpools/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/delete",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/sendMessage/action",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read",
    ]
  }
}
