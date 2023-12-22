module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "avd" {
  source  = "claranet/avd/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  workspace_config = {
    public_network_access_enabled = false
    extra_tags = {
      foo = "bar"
    }
  }

  host_pool_config = {
    # Value will automatically change depending on the Scaling Plan settings
    load_balancer_type = "BreadthFirst"

    scheduled_agent_updates = {
      enabled = true
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
    type = "RemoteApp"
  }

  scaling_plan_config = {
    enabled = true

    # role_assignment = {
    #   # `false` if you do not have permission to create the Role and the Role Assignment, but this must be done somehow
    #   enabled = false
    #
    #   # In case you do not have permsision to retrieve the object ID of the AVD Service Principal
    #   principal_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeeee"
    # }

    schedules = [{
      name                 = "weekdays"
      days_of_week         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      peak_start_time      = "09:00"
      off_peak_start_time  = "22:00"
      ramp_up_start_time   = "08:00"
      ramp_down_start_time = "19:00"
    }]
  }

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]

  extra_tags = {
    purpose = "demo"
  }
}
