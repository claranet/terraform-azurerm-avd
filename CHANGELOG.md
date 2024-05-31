## 7.4.0 (2024-05-31)


### Features

* **AZ-1414:** add `public_network_access` parameter to host pool 290dfec


### Continuous Integration

* **AZ-1391:** update semantic-release config [skip ci] 4727247


### Miscellaneous Chores

* **deps:** enable automerge on renovate 2aef1e8
* **deps:** update dependency opentofu to v1.7.0 631a5de
* **deps:** update dependency opentofu to v1.7.1 146ec3b
* **deps:** update dependency pre-commit to v3.7.1 877fed8
* **deps:** update dependency terraform-docs to v0.18.0 568feb1
* **deps:** update dependency tflint to v0.51.0 c2a77c0
* **deps:** update dependency tflint to v0.51.1 848ae1c
* **deps:** update dependency trivy to v0.50.2 9c97865
* **deps:** update dependency trivy to v0.50.4 597b1b5
* **deps:** update dependency trivy to v0.51.0 ba7d1ff
* **deps:** update dependency trivy to v0.51.1 ff1b89f
* **deps:** update dependency trivy to v0.51.2 ff6f831
* **deps:** update dependency trivy to v0.51.3 26b649b
* **deps:** update dependency trivy to v0.51.4 4ee0b7a
* **pre-commit:** update commitlint hook eec0b61
* **release:** remove legacy `VERSION` file 2c8c1e8

## 7.3.2 (2024-04-18)


### Documentation

* update CHANGELOG links 67ca37f


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] dd222ec

## [7.3.1](https://github.com/claranet/terraform-azurerm-avd/compare/v7.3.0...v7.3.1) (2024-04-12)


### Continuous Integration

* **AZ-1391:** enable release job ([ecc8d31](https://github.com/claranet/terraform-azurerm-avd/commit/ecc8d31915d0d1e949fc7194664dc41d683ff658))
* fix workflow ([f8f94b9](https://github.com/claranet/terraform-azurerm-avd/commit/f8f94b91379ab2086716717782c8c8dd14b49eda))
* **release:** add revert type to semantic-release config ([4c51080](https://github.com/claranet/terraform-azurerm-avd/commit/4c51080737e3c66c1a288a04395943407ea216d5))


### Miscellaneous Chores

* **deps:** update renovate.json ([af435eb](https://github.com/claranet/terraform-azurerm-avd/commit/af435eb294612d9625f411b2005c986aa12d02ea))


### Revert

* **AZ-1310:** revert `validate_environment` value for host pool resource ([be043f4](https://github.com/claranet/terraform-azurerm-avd/commit/be043f45aeb77b18cd06f403626402a4cd208991))

# v7.3.0 - 2024-03-18

Added
  * AZ-1310: Add `Desktop Virtualization User` Role Assignments to Application Group

Changed
  * AZ-1310: Update default `validate_environment` of Host Pool resource (`true` => `false`)
  * AZ-1310: Update default `load_balancer_type` of Host Pool resource (`DepthFirst` => `BreadthFirst`)
  * AZ-1310: Change in method of retrieving AVD Service Principal client ID
  * AZ-1310: Change `var.scaling_plan_config.role_assignment.principal_id` to `var.scaling_plan_config.role_assignment.object_id`
  * AZ-1310: Update example

# v7.2.1 - 2024-01-19

Fixed
  * [GH-1](https://github.com/claranet/terraform-azurerm-avd/issues/1): Fix `coalesce` function

# v7.2.0 - 2024-01-05

Added
  * AZ-1310: Add an optional Scaling Plan for the Host Pool (with a dedicated Role Definition)
  * AZ-1310: Add the `public_network_access_enabled` parameter to the Workspace resource (minimum version of the AzureRM Provider is now `3.69` to support this parameter)
  * AZ-1310: Add the `default_desktop_display_name` parameter to the Application Group resource
  * AZ-1310: Add the `personal_desktop_assignment_type`, `preferred_app_group_type` and `start_vm_on_connect` parameters to the Host Pool resource
  * AZ-1310: Add outputs

Changed
  * AZ-1310: Change resources slug in naming to improve consistency (bumping the module version requires the use of custom names for each resource)
  * AZ-1310: Change the `hostpool_config` variable to `host_pool_config`
  * AZ-1310: Change the `hostpool_custom_name` variable to `host_pool_custom_name`
  * AZ-1310: Update default `friendly_name` of Workspace and Application Group resources
  * AZ-1310: Update default `description` of the Workspace resource
  * AZ-1310: Better management of the Host Pool registration info (it is always created now and expires within 48 hours by default, thanks to the `host_registration_expires_in_in_hours` parameter in the Host Pool configuration which replaces the `registration_expiration_date` parameter)

Fixed
  * AZ-1310: Extra tags are now correctly shared between resources

# v7.1.0 - 2023-12-08

Added
  * AZ-1299: Add `application_group_id` output

# v7.0.0 - 2023-10-06

Added
  * AZ-1174: Azure Virtual Desktop module first release
