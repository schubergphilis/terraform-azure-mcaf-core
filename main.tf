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
  source = "github.com/schubergphilis/terraform-azure-mcaf-key-vault.git?ref=v0.3.1"

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
    default_action                  = "Deny"
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
  }

  tags = var.tags
}
