# Telemetry is collected by creating an empty ARM deployment with a specific name
# If you want to disable telemetry, you can set the disable_telemetry variable to true

# This file contains telemetry for the workload module

# The following locals are used to create the bitfield data, dependent on the module configuration
locals {
  # Bitfield bit 1 (LSB): Is deploy workload enabled?
  telem_management_hub_deploy = local.disable_telemetry ? 1 : 0
}

# The following locals calculate the telemetry bit field by summing the above locals and then representing as hexadecimal
# Hex number is represented as four digits wide and is zero padded
locals {
  telem_management_hub_bitfield_telemetry = (
    local.telem_management_hub_deploy
  )
  telem_management_hub_bitfield_hex = format("%04x", local.telem_management_hub_bitfield_telemetry)
}

# This constructs the ARM deployment name that is used for the telemetry.
# We shouldn't ever hit the 64 character limit but use substr just in case
locals {
  telem_management_hub_arm_deployment_name = substr(
    format(
      "pid-%s_%s_%s_%s",
      local.telem_management_hub_puid,
      local.org_name,
      local.telem_management_hub_bitfield_hex,
      local.telem_random_hex,
    ),
    0,
    64
  )
}

# Condition to determine whether we create the management hub telemetry deployment
locals {
  telem_management_hub_deployment_enabled = !local.disable_telemetry
}