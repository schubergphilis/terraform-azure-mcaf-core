variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "Location of the resources to create"
  type        = string
}

## Key Vault variables
variable "key_vault" {
  type = object({
    name                            = string
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    enable_rbac_authorization       = optional(bool, true)
    purge_protection                = optional(bool, true)
    soft_delete_retention_days      = optional(number, 30)
    sku                             = optional(string, "standard")
    public_network_access_enabled   = optional(bool, false)
    ip_rules                        = optional(set(string), [])
    subnet_ids                      = optional(set(string), [])
    network_bypass                  = optional(string, "None")
    cmk_keys_create                 = optional(bool, true)
    cmkrsa_key_name                 = optional(string, "cmkrsa")
    cmkec_key_name                  = optional(string, "cmkec")
    cmk_rotation_period             = optional(string, "P18M")
    cmk_expiry_period               = optional(string, "P2Y")
    cmk_notify_period               = optional(string, "P30D")
    cmk_expiration_date             = optional(string, null)
  })
}

variable "key_vault_key" {
  type = map(object({
    name            = optional(string, null)
    curve           = optional(string, null)
    size            = optional(number, null)
    type            = optional(string, null)
    opts            = optional(set(string), null)
    expiration_date = optional(string, null)
    not_before_date = optional(string, null)
    rotation_policy = optional(object({
      automatic = optional(object({
        time_after_creation = optional(string, null)
        time_before_expiry  = optional(string, null)
      }), null)
      expire_after         = optional(string, null)
      notify_before_expiry = optional(string, null)
    }), null)
    tags = optional(map(string), {})
  }))
  default     = {}
  description = <<DESCRIPTION
This map describes the configuration for Azure Key Vault keys.

- `key_vault_id` - (Required) The ID of the Key Vault.
- `key_type` - (Required) The type of the key.
- `key_size` - (Required) The size of the key.
- `key_opts` - (Required) The key operations that are permitted.

Example Inputs:

```hcl
  key_vault_key = {
    key_rsa = {
      type = "RSA"
      size = 4096
      opts = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]
    }
    key_ec = {
      type = "EC"
      curve = "P-256"
      opts = ["sign", "verify"]
    }
  }
```
DESCRIPTION
}

## Reocvery Services Vault variables
variable "recovery_services_vault" {
  type = object({
    name                             = string
    location                         = string
    public_network_access_enabled    = optional(bool, false)
    sku                              = optional(string, "Standard")
    storage_mode_type                = optional(string, "GeoRedundant")
    cross_region_restore_enabled     = optional(bool, false)
    soft_delete_enabled              = optional(bool, true)
    system_assigned_identity_enabled = optional(bool, true)
    immutability                     = optional(string, null),
  })
}

variable "rsv_encryption" {
  type = object({
    cmk_encryption_enabled = optional(string)
    cmk_identity           = optional(string)
    cmk_key_vault_key_id   = optional(string)
  })
  default = {
    cmk_encryption_enabled = false
    cmk_identity           = null
    cmk_key_vault_key_id   = null
  }
}

variable "vm_backup_policy" {
  type = map(object({
    name                           = string
    timezone                       = string
    instant_restore_retention_days = optional(number, null)
    policy_type                    = string
    frequency                      = string

    retention_daily = optional(number, null)

    backup = object({
      time          = string
      hour_interval = optional(number, null)
      hour_duration = optional(number, null)
      weekdays      = optional(list(string), [])
    })

    retention_weekly = optional(object({
      count    = optional(number, 7)
      weekdays = optional(list(string), [])
    }), {})

    retention_monthly = optional(object({
      count             = optional(number, 0)
      weekdays          = optional(list(string), [])
      weeks             = optional(list(string), [])
      days              = optional(list(number), [])
      include_last_days = optional(bool, false)
    }), {})

    retention_yearly = optional(object({
      count             = optional(number, 0)
      months            = optional(list(string), [])
      weekdays          = optional(list(string), [])
      weeks             = optional(list(string), [])
      days              = optional(list(number), [])
      include_last_days = optional(bool, false)
    }), {})
  }))
  default     = null
  description = <<DESCRIPTION
    A map of objects for backup and retention options.

    - `name` - (Required) The name of the backup policy.
    - `timezone` - (Required) The timezone for the backup policy.
    - `instant_restore_retention_days` - (Optional) The number of days to retain instant restore points.
    - `instant_restore_resource_group` - (Optional) A map of resource group options for instant restore.
        - `prefix` - (Optional) Prefix for the resource group name.
        - `suffix` - (Optional) Suffix for the resource group name.
    - `policy_type` - (Required) The type of the backup policy.
    - `frequency` - (Required) The frequency of the backup. Possible values are Hourly, Daily, and Weekly.

    - `backup` - (Required) Backup options.
        - `time` - (Required) Specify time in a 24-hour format HH:MM. Example: "22:00".
        - `hour_interval` - (Optional) Interval in hours at which backup is triggered. Possible values are 4, 6, 8, and 12. This is used when frequency is Hourly.
        - `hour_duration` - (Optional) Duration of the backup window in hours. Possible values are between 4 and 24. This is used when frequency is Hourly.
        - `weekdays` - (Optional) The days of the week to perform backups on. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday. This is used when frequency is Weekly.

    - `retention_daily` - (Optional) The number of daily backups to retain.
    - `retention_weekly` - (Optional) A map of weekly retention options.
        - `count` - (Optional) The number of weekly backups to retain.
        - `weekdays` - (Optional) The weekdays to retain backups. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday.
    - `retention_monthly` - (Optional) A map of monthly retention options.
        - `count` - (Required) The number of monthly backups to retain. Must be between 1 and 9999.
        - `weekdays` - (Optional) The weekdays to retain backups. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday.
        - `weeks` - (Optional) The weeks of the month to retain backups. Must be one of First, Second, Third, Fourth, Last.
        - `days` - (Optional) The days of the month to retain backups. Must be between 1 and 31.
        - `include_last_days` - (Optional) Include the last day of the month. Defaults to false.
    - `retention_yearly` - (Optional) A map of yearly retention options.
        - `count` - (Required) The number of yearly backups to retain. Must be between 1 and 9999.
        - `months` - (Required) The months of the year to retain backups. Must be one of January, February, March, April, May, June, July, August, September, October, November, or December.
        - `weekdays` - (Optional) The weekdays to retain backups. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday.
        - `weeks` - (Optional) The weeks of the month to retain backups. Must be one of First, Second, Third, Fourth, Last.
        - `days` - (Optional) The days of the month to retain backups. Must be between 1 and 31.
        - `include_last_days` - (Optional) Include the last day of the month. Defaults to false.

    Example:
      vm_backup_policy = {
        example_policy = {
          name                           = "example_policy"
          timezone                       = "UTC"
          policy_type                    = "VMBkp"
          frequency                      = "Hourly"
          backup = {
            time          = "22:00"
            hour_interval = 6
            hour_duration = 12
          }
          retention_daily = 7
          retention_weekly = {
            count    = 7
            weekdays = ["Monday", "Wednesday"]
          }
          retention_monthly = {
            count    = 5
            days     = [3, 10, 20]
          }
          retention_yearly = {
            count  = 5
            months = ["January", "July"]
            days   = [3, 10, 20]
          }
        }
      }
    DESCRIPTION
}

variable "file_share_backup_policy" {
  type = map(object({
    name            = string
    timezone        = string
    frequency       = string
    retention_daily = optional(number, null)

    backup = object({
      time = string
      hourly = optional(object({
        interval        = number
        start_time      = string
        window_duration = number
      }))
    })

    retention_weekly = optional(object({
      count    = optional(number, 7)
      weekdays = optional(list(string), [])
    }), {})

    retention_monthly = optional(object({
      count             = optional(number, 0)
      weekdays          = optional(list(string), [])
      weeks             = optional(list(string), [])
      days              = optional(list(number), [])
      include_last_days = optional(bool, false)
    }), {})

    retention_yearly = optional(object({
      count             = optional(number, 0)
      months            = optional(list(string), [])
      weekdays          = optional(list(string), [])
      weeks             = optional(list(string), [])
      days              = optional(list(number), [])
      include_last_days = optional(bool, false)
    }), {})
  }))
  default     = null
  description = <<DESCRIPTION
    A map objects for backup and retation options.

    - `name` - (Optional) The name of the private endpoint. One will be generated if not set.
    - `role_assignments` - (Optional) A map of role assignments to create on the 

    - `backup` - (required) backup options.
        - `frequency` - (Required) Sets the backup frequency. Possible values are hourly, Daily and Weekly.
        - `time` - (required) Specify time in a 24 hour format HH:MM. "22:00"
        - `hour_interval` - (Optional) Interval in hour at which backup is triggered. Possible values are 4, 6, 8 and 12. This is used when frequency is hourly. 6
        - `hour_duration` -  (Optional) Duration of the backup window in hours. Possible values are between 4 and 24 This is used when frequency is hourly. 12
        - `weekdays` -  (Optional) The days of the week to perform backups on. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday. This is used when frequency is Weekly. ["Tuesday", "Saturday"]
    - `retention_daily` - (Optional)
      - `count` - 
    - `retantion_weekly` -
      - `count` -
      - `weekdays` -
    - `retantion_monthly` -
      - `count` -  # (Required) The number of monthly backups to keep. Must be between 1 and 9999
      - `weekdays` - (Optional) The weekday backups to retain . Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday.
      - `weeks` -  # (Optional) The weeks of the month to retain backups of. Must be one of First, Second, Third, Fourth, Last.
      - `days` -  # (Optional) The days of the month to retain backups of. Must be between 1 and 31.
      - `include_last_days` -  # (Optional) Including the last day of the month, default to false.
    - `retantion_yearly` -
      - `months` - # (Required) The months of the year to retain backups of. Must be one of January, February, March, April, May, June, July, August, September, October, November and December.
      - `count` -  # (Required) The number of monthly backups to keep. Must be between 1 and 9999
      - `weekdays` - (Optional) The weekday backups to retain . Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday.
      - `weeks` -  # (Optional) The weeks of the month to retain backups of. Must be one of First, Second, Third, Fourth, Last.
      - `days` -  # (Optional) The days of the month to retain backups of. Must be between 1 and 31.
      - `include_last_days` -  # (Optional) Including the last day of the month, default to false.

    example:
      retentions = {
      rest1 = {
        backup = {
          frequency     = "hourly"
          time          = "22:00"
          hour_interval = 6
          hour_duration = 12
          # weekdays      = ["Tuesday", "Saturday"]
        }
        retention_daily = 7
        retention_weekly = {
          count    = 7
          weekdays = ["Monday", "Wednesday"]

        }
        retention_monthly = {
          count = 5
          # weekdays =  ["Tuesday","Saturday"]
          # weeks = ["First","Third"]
          days = [3, 10, 20]
        }
        retention_yearly = {
          count  = 5
          months = []
          # weekdays =  ["Tuesday","Saturday"]
          # weeks = ["First","Third"]
          days = [3, 10, 20]
        }

        }
      }
    DESCRIPTION
}

## Backup Vault variables
variable "backup_vault" {
  type = object({
    name                       = string
    location                   = string
    redundancy                 = string
    immutability               = string // accepted values are "Disabled"", "Locked", "Unlocked" 
    soft_delete_retention_days = number
    cmk_key_vault_key_id       = optional(string, null)
  })
  default = null
}

variable "blob_storage_backup_policy" {
  type = map(object({
    retention_duration              = string
    backup_repeating_time_intervals = list(string) // example ["R/2025-02-21T14:00:00+00:00/P1D"]
  }))
  default = null
}

## Boot Diag storage account variables
variable "boot_diag_storage_account" {
  description = "Configure a Boot diagnostics Storage Account for the subscription, Boot Diagnostics Storage Accounts must be publically accessible, do not support Zone Redundant Storage and do* not support storage tiering settings"
  type = object({
    name                              = string
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "LRS")
    access_tier                       = optional(string, "Hot")
    infrastructure_encryption_enabled = optional(bool, true)
    cmk_encryption_enabled            = optional(bool, false)
    system_assigned_identity_enabled  = optional(bool, false)
    user_assigned_identities          = optional(set(string), [])
    ip_rules                          = optional(set(string), null)
    storage_management_policy = optional(object({
      blob_delete_retention_days      = optional(number, 90)
      container_delete_retention_days = optional(number, 90)
    }), null)
    immutability_policy = optional(object({
      state                         = optional(string, "Unlocked")
      allow_protected_append_writes = optional(bool, true)
      period_since_creation_in_days = optional(number, 14)
    }), null)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
