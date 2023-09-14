locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  avd_name = coalesce(var.custom_name, data.azurecaf_name.avd.result)
}
