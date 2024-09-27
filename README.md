# Azure Virtual Desktop

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/avd/azurerm/)

Terraform module to deploy an [Azure Virtual Desktop](https://learn.microsoft.com/en-us/azure/virtual-desktop/overview).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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

  resource_group_name = module.rg.resource_group_name

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
```

## Providers

| Name | Version |
|------|---------|
| azuread | ~> 2.47 |
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.101 |
| time | ~> 0.12 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics\_app\_group | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |
| diagnostics\_host\_pool | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |
| diagnostics\_scaling\_plan | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |
| diagnostics\_workspace | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.app_group_role_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.scaling_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.scaling_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_virtual_desktop_application_group.app_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.host_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration_info](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_scaling_plan.scaling_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) | resource |
| [azurerm_virtual_desktop_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.workspace_app_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [time_rotating.time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_service_principal.avd_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurecaf_name.avd_app_group](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.avd_host_pool](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.avd_scaling_plan](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.avd_workspace](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_group\_config | AVD Application Group specific configuration. | <pre>object({<br>    friendly_name                = optional(string)<br>    default_desktop_display_name = optional(string)<br>    description                  = optional(string)<br>    type                         = optional(string, "Desktop")<br>    role_assignments_object_ids  = optional(list(string), [])<br>    extra_tags                   = optional(map(string))<br>  })</pre> | `{}` | no |
| application\_group\_custom\_name | Custom Azure Virtual Desktop Application Group name, generated if not set. | `string` | `""` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add on resources. | `map(string)` | `{}` | no |
| host\_pool\_config | AVD Host Pool specific configuration. | <pre>object({<br>    friendly_name                         = optional(string)<br>    description                           = optional(string)<br>    validate_environment                  = optional(bool, true)<br>    custom_rdp_properties                 = optional(string, "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;")<br>    public_network_access                 = optional(string, "Enabled")<br>    type                                  = optional(string, "Pooled")<br>    load_balancer_type                    = optional(string, "BreadthFirst")<br>    personal_desktop_assignment_type      = optional(string, "Automatic")<br>    maximum_sessions_allowed              = optional(number, 16)<br>    preferred_app_group_type              = optional(string)<br>    start_vm_on_connect                   = optional(bool, false)<br>    host_registration_expires_in_in_hours = optional(number, 48)<br>    scheduled_agent_updates = optional(object({<br>      enabled                   = optional(bool, false)<br>      timezone                  = optional(string, "UTC") # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/<br>      use_session_host_timezone = optional(bool, false)<br>      schedules = optional(list(object({<br>        day_of_week = string<br>        hour_of_day = number<br>      })), [])<br>    }), {})<br>    extra_tags = optional(map(string))<br>  })</pre> | `{}` | no |
| host\_pool\_custom\_name | Custom Azure Virtual Desktop host pool name, generated if not set. | `string` | `""` | no |
| location | Azure region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| resource\_group\_name | Name of the resource group. | `string` | n/a | yes |
| scaling\_plan\_config | AVD Scaling Plan specific configuration. | <pre>object({<br>    enabled       = optional(bool, false)<br>    friendly_name = optional(string)<br>    description   = optional(string)<br>    exclusion_tag = optional(string)<br>    timezone      = optional(string, "UTC") # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/<br>    schedules = optional(list(object({<br>      name                                 = string<br>      days_of_week                         = list(string)<br>      peak_start_time                      = string<br>      peak_load_balancing_algorithm        = optional(string, "BreadthFirst")<br>      off_peak_start_time                  = string<br>      off_peak_load_balancing_algorithm    = optional(string, "DepthFirst")<br>      ramp_up_start_time                   = string<br>      ramp_up_load_balancing_algorithm     = optional(string, "BreadthFirst")<br>      ramp_up_capacity_threshold_percent   = optional(number, 75)<br>      ramp_up_minimum_hosts_percent        = optional(number, 33)<br>      ramp_down_start_time                 = string<br>      ramp_down_capacity_threshold_percent = optional(number, 5)<br>      ramp_down_force_logoff_users         = optional(string, false)<br>      ramp_down_load_balancing_algorithm   = optional(string, "DepthFirst")<br>      ramp_down_minimum_hosts_percent      = optional(number, 33)<br>      ramp_down_notification_message       = optional(string, "Please log off in the next 45 minutes...")<br>      ramp_down_stop_hosts_when            = optional(string, "ZeroSessions")<br>      ramp_down_wait_time_minutes          = optional(number, 45)<br>    })), [])<br>    role_assignment = optional(object({<br>      enabled   = optional(bool, true)<br>      object_id = optional(string)<br>    }), {})<br>    extra_tags = optional(map(string))<br>  })</pre> | `{}` | no |
| scaling\_plan\_custom\_name | Custom Azure Virtual Desktop Scaling Plan name, generated if not set. | `string` | `""` | no |
| stack | Project stack name. | `string` | n/a | yes |
| workspace\_config | AVD Workspace specific configuration. | <pre>object({<br>    friendly_name                 = optional(string)<br>    description                   = optional(string)<br>    public_network_access_enabled = optional(bool)<br>    extra_tags                    = optional(map(string))<br>  })</pre> | `{}` | no |
| workspace\_custom\_name | Custom Azure Virtual Desktop workspace name, generated if not set. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_group | AVD Application Group object output. |
| application\_group\_id | AVD Application Group ID. |
| application\_group\_name | AVD Application Group name. |
| avd\_service\_principal\_client\_id | AVD Service Principal Client ID (Application ID). |
| avd\_service\_principal\_name | AVD Service Principal name. |
| avd\_service\_principal\_object\_id | AVD Service Principal Object ID (Principal ID). |
| host\_pool | AVD Host Pool object output. |
| host\_pool\_id | AVD Host Pool ID. |
| host\_pool\_name | AVD Host Pool name. |
| host\_registration\_token | AVD host registration token. |
| host\_registration\_token\_expiration\_date | AVD host registration token expiration date. |
| scaling\_plan | AVD Scaling Plan object output. |
| scaling\_plan\_id | AVD Scaling Plan ID. |
| scaling\_plan\_name | AVD Scaling Plan name. |
| scaling\_plan\_role\_definition | AVD Scaling Plan Role Definition object output. |
| scaling\_plan\_role\_definition\_id | AVD Scaling Plan Role Definition ID. |
| scaling\_plan\_role\_definition\_name | AVD Scaling Plan Role Definition name. |
| workspace | AVD Workspace object output. |
| workspace\_id | AVD Workspace ID. |
| workspace\_name | AVD Workspace name. |
<!-- END_TF_DOCS -->
