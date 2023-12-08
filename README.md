# Azure Virtual Desktop
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/avd/azurerm/)

Azure module to deploy a [Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/xxxxxxx).

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

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "avd" {
  source  = "claranet/avd/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.39 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics\_app\_group | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |
| diagnostics\_hostpool | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |
| diagnostics\_workspace | claranet/diagnostic-settings/azurerm | ~> 6.5.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_desktop_application_group.app_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.host_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.registration_info](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.ws_appgroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [azurecaf_name.avd_app_group](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.avd_hostpool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.avd_workspace](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_group\_config | AVD Application Group specific configuration. | <pre>object({<br>    friendly_name = optional(string)<br>    description   = optional(string)<br>    type          = optional(string, "Desktop")<br>  })</pre> | `{}` | no |
| application\_group\_custom\_name | Custom Azure Virtual Desktop Application Group name, generated if not set | `string` | `""` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add on resources. | `map(string)` | `{}` | no |
| hostpool\_config | AVD Host Pool specific configuration. | <pre>object({<br>    friendly_name                = optional(string)<br>    description                  = optional(string)<br>    validate_environment         = optional(bool, true)<br>    custom_rdp_properties        = optional(string, "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;")<br>    type                         = optional(string, "Pooled")<br>    maximum_sessions_allowed     = optional(number, 16)<br>    load_balancer_type           = optional(string, "DepthFirst")<br>    host_registration_enabled    = optional(bool, false)<br>    registration_expiration_date = optional(string)<br>  })</pre> | `{}` | no |
| hostpool\_custom\_name | Custom Azure Virtual Desktop host pool name, generated if not set | `string` | `""` | no |
| location | Azure region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| resource\_group\_name | Name of the resource group. | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| workspace\_config | AVD Workspace specific configuration. | <pre>object({<br>    friendly_name = optional(string)<br>    description   = optional(string)<br>  })</pre> | `{}` | no |
| workspace\_custom\_name | Custom Azure Virtual Desktop workspace name, generated if not set | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_group\_id | AVD Application Group ID |
| host\_pool | AVD Host Pool output object. |
| host\_pool\_id | AVD Host Pool ID. |
| host\_pool\_name | AVD Host Pool name. |
| host\_registration\_token | AVD host registration token. |
| host\_registration\_token\_expiration\_date | AVD host registration token expiration date. |
| workspace | AVD Workspace output object. |
| workspace\_id | AVD Workspace ID. |
| workspace\_name | AVD Workspace name. |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: xxxx
