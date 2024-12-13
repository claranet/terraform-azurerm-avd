locals {
  timezone = "Romance Standard Time"

  # Entra ID
  avd_group_display_name = "AVD Users"
  avd_user_01_object_id  = "axxxxxxx-axxx-axxx-axxx-axxxxxxxxxxx"
  avd_user_02_object_id  = "bxxxxxxx-bxxx-bxxx-bxxx-bxxxxxxxxxxx"
}

data "azuread_group" "avd_group" {
  display_name     = local.avd_group_display_name
  security_enabled = true
}

module "avd" {
  source  = "claranet/avd/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  workspace_config = {
    extra_tags = {
      foo = "bar"
    }
  }

  host_pool_config = {
    load_balancer_type       = "DepthFirst" # Value will automatically change depending on the Scaling Plan settings
    maximum_sessions_allowed = 24
    scheduled_agent_updates = {
      enabled  = true
      timezone = local.timezone
      schedules = [
        {
          day_of_week = "Sunday"
          hour_of_day = 8
        },
        {
          day_of_week = "Wednesday"
          hour_of_day = 22
        },
      ]
    }
  }

  application_group_config = {
    role_assignments_object_ids = concat(
      data.azuread_group.avd_group.members,
      [
        local.avd_user_01_object_id,
        local.avd_user_02_object_id,
      ],
    )
  }

  applications_config = {
    app-1 = {
      path = "C:\\application\\app-1.exe"
    }
  }

  scaling_plan_config = {
    enabled  = true
    timezone = local.timezone
    schedules = [
      {
        name                 = "weekdays"
        days_of_week         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        ramp_up_start_time   = "08:00"
        peak_start_time      = "09:00"
        ramp_down_start_time = "19:00"
        off_peak_start_time  = "22:00"
      },
      {
        name                 = "weekend"
        days_of_week         = ["Saturday", "Sunday"]
        ramp_up_start_time   = "09:00"
        peak_start_time      = "10:00"
        ramp_down_start_time = "17:00"
        off_peak_start_time  = "20:00"
      },
    ]
    # role_assignment = {
    #   enabled   = false                                   # `false` if you do not have permission to create the Role and the Role Assignment, but this must be done somehow
    #   object_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeeee" # In case you do not have permsision to retrieve the object ID of the AVD Service Principal
    # }
  }

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]

  extra_tags = {
    purpose = "demo"
  }
}
