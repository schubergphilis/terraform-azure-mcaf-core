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
  })
}

variable "recovery_service_vault" {
  description = "Configuration object for Azure Recovery Services Vault"

  type = object({
    name                                 = string
    public_network_access_enabled        = optional(bool, false)
    sku                                  = optional(string, "Standard")
    storage_mode_type                    = optional(string, "ZoneRedundant")
    soft_delete_enabled                  = optional(bool, true)
    immutability                         = optional(bool, null)
    cmk_encryption_enabled               = optional(bool, false)
    cmk_identity                         = optional(string, null)
    cmk_key_vault_key_id                 = optional(string)
    system_assigned_identity_enabled     = optional(bool, false)
  })

  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

