# Unreleased

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
