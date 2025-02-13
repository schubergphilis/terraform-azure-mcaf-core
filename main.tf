data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}

module "keyvault_with_cmk" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-key-vault.git?ref=v0.3.2"

  key_vault = {
    name                            = var.key_vault.name
    tenant_id                       = data.azurerm_client_config.current.tenant_id
    resource_group_name             = azurerm_resource_group.this.name
    location                        = var.location
    enabled_for_disk_encryption     = var.key_vault.enabled_for_disk_encryption
    enabled_for_deployment          = var.key_vault.enabled_for_deployment
    enabled_for_template_deployment = var.key_vault.enabled_for_template_deployment
    enable_rbac_authorization       = var.key_vault.enable_rbac_authorization
    purge_protection                = true
    soft_delete_retention_days      = 30
    public_network_access_enabled   = var.key_vault.public_network_access_enabled
    default_action                  = var.key_vault.public_network_access_enabled ? "Allow" : "Deny"
    sku                             = var.key_vault.sku
    ip_rules                        = length(var.key_vault.ip_rules) == 0 ? null : var.key_vault.ip_rules
    subnet_ids                      = length(var.key_vault.subnet_ids) == 0 ? null : var.key_vault.subnet_ids
    network_bypass                  = "AzureServices"
    cmk_keys_create                 = var.key_vault.cmk_keys_create
    cmk_rotation_period             = var.key_vault.cmk_rotation_period
    cmk_expiry_period               = var.key_vault.cmk_expiry_period
    cmk_notify_period               = var.key_vault.cmk_notify_period
    cmkrsa_key_name                 = var.key_vault.cmkrsa_key_name
    cmkec_key_name                  = var.key_vault.cmkec_key_name
    cmk_expiration_date             = var.key_vault.cmk_expiration_date
  }

  key_vault_key = var.key_vault_key
  tags          = var.tags
}

module "recovery_services_vault" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-recovery-vault.git?ref=v0.1.0"
  count  = var.recovery_services_vault != null ? 1 : 0

  name                             = var.recovery_services_vault.name
  resource_group_name              = azurerm_resource_group.this.name
  location                         = var.location
  public_network_access_enabled    = var.recovery_services_vault.public_network_access_enabled
  sku                              = var.recovery_services_vault.sku
  storage_mode_type                = var.recovery_services_vault.storage_mode_type
  soft_delete_enabled              = var.recovery_services_vault.soft_delete_enabled
  immutability                     = var.recovery_services_vault.immutability
  cmk_encryption_enabled           = var.recovery_services_vault.cmk_encryption_enabled
  system_assigned_identity_enabled = var.recovery_services_vault.system_assigned_identity_enabled
  cmk_identity                     = var.recovery_services_vault.cmk_identity
  cmk_key_vault_key_id             = module.keyvault_with_cmk.cmkrsa_versionless_id
  user_assigned_resource_ids       = var.recovery_services_vault.user_assigned_resource_ids
  tags                             = var.tags
}

module "boot_diag_storage_account" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-storage-account.git?ref=v0.7.0"
  count  = var.boot_diag_storage_account != null ? 1 : 0

  name                              = var.boot_diag_storage_account.name
  location                          = var.location
  resource_group_name               = azurerm_resource_group.this.name
  account_tier                      = var.boot_diag_storage_account.account_tier
  account_replication_type          = var.boot_diag_storage_account.account_replication_type
  account_kind                      = "StorageV2"
  access_tier                       = var.boot_diag_storage_account.access_tier
  infrastructure_encryption_enabled = var.boot_diag_storage_account.infrastructure_encryption_enabled
  cmk_key_vault_id                  = var.boot_diag_storage_account.cmk_encryption_enabled ? module.keyvault_with_cmk.key_vault_id : null
  cmk_key_name                      = var.boot_diag_storage_account.cmk_encryption_enabled ? module.keyvault_with_cmk.cmkrsa_key_name : null
  system_assigned_identity_enabled  = var.boot_diag_storage_account.system_assigned_identity_enabled
  user_assigned_identities          = var.boot_diag_storage_account.user_assigned_identities
  immutability_policy               = var.boot_diag_storage_account.immutability_policy
  network_configuration = {
    https_traffic_only_enabled      = true
    allow_nested_items_to_be_public = true
    public_network_access_enabled   = true
    default_action                  = var.boot_diag_storage_account.ip_rules != null ? "Deny" : "Allow"
    ip_rules                        = var.boot_diag_storage_account.ip_rules
    bypass                          = ["AzureServices"]
  }
  storage_management_policy = var.boot_diag_storage_account.storage_management_policy
  tags                      = var.tags
}