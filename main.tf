data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.location
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}

module "keyvault_with_cmk" {
  source = "github.com/schubergphilis/terraform-azure-mcaf-key-vault.git"

  key_vault = {
    name                            = var.key_vault.name
    tenant_id                       = data.azurerm_client_config.current.tenant_id
    resource_group_name             = azurerm_resource_group.this.name
    location                        = var.location
    enabled_for_disk_encryption     = true
    enabled_for_deployment          = false
    enabled_for_template_deployment = false
    enable_rbac_authorization       = true
    purge_protection                = true
    soft_delete_retention_days      = 30
    sku                             = "standard"
    ip_rules                        = length(var.key_vault.ip_rules) == 0 ? null : var.key_vault.ip_rules
    subnet_ids                      = length(var.key_vault.subnet_ids) == 0 ? null : var.key_vault.subnet_ids
    network_bypass                  = "AzureServices"
    cmk_keys_create                 = true
    cmkrsa_key_name                 = var.key_vault.cmkrsa_key_name
    cmkec_key_name                  = var.key_vault.cmkec_key_name
  }

  tags = var.tags
}
