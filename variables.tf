variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "Location of the resources to create"
  type        = string
}

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
    ip_rules                        = optional(list(string), [])
    subnet_ids                      = optional(list(string), [])
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
    opts            = optional(list(string), null)
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

variable "recovery_services_vault" {
  description = "Configuration object for Azure Recovery Services Vault"

  type = object({
    name                             = string
    public_network_access_enabled    = optional(bool, false)
    sku                              = optional(string, "Standard")
    storage_mode_type                = optional(string, "ZoneRedundant")
    soft_delete_enabled              = optional(bool, true)
    immutability                     = optional(bool, null)
    cmk_encryption_enabled           = optional(bool, false)
    cmk_identity                     = optional(string, null)
    cmk_key_vault_key_id             = optional(string, null)
    system_assigned_identity_enabled = optional(bool, false)
    user_assigned_resource_ids       = optional(list(string), [])
  })

  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "boot_diag_storage_account" {
  type = object({
    name                              = string
    public_network_access_enabled     = optional(bool, false)
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "ZRS")
    access_tier                       = optional(string, "Cool")
    log_retention_days                = optional(number, null)
    move_to_cold_after_days           = optional(number, null)
    move_to_archive_after_days        = optional(number, null)
    snapshot_retention_days           = optional(number, 90)
    infrastructure_encryption_enabled = optional(bool, true)
    cmk_key_vault_id                  = optional(string, null)
    cmk_key_name                      = optional(string, null)
    system_assigned_identity_enabled  = optional(bool, false)
    user_assigned_identities          = optional(list(string), [])
    immutability_policy = optional(object({
      state                         = optional(string, "Unlocked")
      allow_protected_append_writes = optional(bool, true)
      period_since_creation_in_days = optional(number, 14)
    }), null)
  })
  default = null
}
