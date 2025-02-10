# terraform-azure-mcaf-core
Terraform module to create the Core component of each workload, currently only implements Terraform-azure-mcaf-key-vault

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_boot_diag_storage_account"></a> [boot\_diag\_storage\_account](#module\_boot\_diag\_storage\_account) | github.com/schubergphilis/terraform-azure-mcaf-storage-account.git | v0.7.0 |
| <a name="module_keyvault_with_cmk"></a> [keyvault\_with\_cmk](#module\_keyvault\_with\_cmk) | github.com/schubergphilis/terraform-azure-mcaf-key-vault.git | v0.3.2 |
| <a name="module_recovery_services_vault"></a> [recovery\_services\_vault](#module\_recovery\_services\_vault) | github.com/schubergphilis/terraform-azure-mcaf-recovery-vault.git | v0.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | n/a | <pre>object({<br>    name                            = string<br>    enabled_for_disk_encryption     = optional(bool, false)<br>    enabled_for_deployment          = optional(bool, false)<br>    enabled_for_template_deployment = optional(bool, false)<br>    enable_rbac_authorization       = optional(bool, true)<br>    purge_protection                = optional(bool, true)<br>    soft_delete_retention_days      = optional(number, 30)<br>    sku                             = optional(string, "standard")<br>    public_network_access_enabled   = optional(bool, false)<br>    ip_rules                        = optional(set(string), [])<br>    subnet_ids                      = optional(set(string), [])<br>    network_bypass                  = optional(string, "None")<br>    cmk_keys_create                 = optional(bool, true)<br>    cmkrsa_key_name                 = optional(string, "cmkrsa")<br>    cmkec_key_name                  = optional(string, "cmkec")<br>    cmk_rotation_period             = optional(string, "P18M")<br>    cmk_expiry_period               = optional(string, "P2Y")<br>    cmk_notify_period               = optional(string, "P30D")<br>    cmk_expiration_date             = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resources to create | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the resources. | `string` | n/a | yes |
| <a name="input_boot_diag_storage_account"></a> [boot\_diag\_storage\_account](#input\_boot\_diag\_storage\_account) | Configure a Boot diagnostics Storage Account for the subscription, Boot Diagnostics Storage Accounts must be publically accessible, do not support Zone Redundant Storage and do* not support storage tiering settings | <pre>object({<br>    name                              = string<br>    account_tier                      = optional(string, "Standard")<br>    account_replication_type          = optional(string, "LRS")<br>    access_tier                       = optional(string, "Hot")<br>    infrastructure_encryption_enabled = optional(bool, true)<br>    cmk_encryption_enabled            = optional(bool, false)<br>    system_assigned_identity_enabled  = optional(bool, false)<br>    user_assigned_identities          = optional(set(string), [])<br>    ip_rules                          = optional(set(string), null)<br>    storage_management_policy = optional(object({<br>      blob_delete_retention_days      = optional(number, 90)<br>      container_delete_retention_days = optional(number, 90)<br>    }), null)<br>    immutability_policy = optional(object({<br>      state                         = optional(string, "Unlocked")<br>      allow_protected_append_writes = optional(bool, true)<br>      period_since_creation_in_days = optional(number, 14)<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_key_vault_key"></a> [key\_vault\_key](#input\_key\_vault\_key) | This map describes the configuration for Azure Key Vault keys.<br><br>- `key_vault_id` - (Required) The ID of the Key Vault.<br>- `key_type` - (Required) The type of the key.<br>- `key_size` - (Required) The size of the key.<br>- `key_opts` - (Required) The key operations that are permitted.<br><br>Example Inputs:<pre>hcl<br>  key_vault_key = {<br>    key_rsa = {<br>      type = "RSA"<br>      size = 4096<br>      opts = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]<br>    }<br>    key_ec = {<br>      type = "EC"<br>      curve = "P-256"<br>      opts = ["sign", "verify"]<br>    }<br>  }</pre> | <pre>map(object({<br>    name            = optional(string, null)<br>    curve           = optional(string, null)<br>    size            = optional(number, null)<br>    type            = optional(string, null)<br>    opts            = optional(set(string), null)<br>    expiration_date = optional(string, null)<br>    not_before_date = optional(string, null)<br>    rotation_policy = optional(object({<br>      automatic = optional(object({<br>        time_after_creation = optional(string, null)<br>        time_before_expiry  = optional(string, null)<br>      }), null)<br>      expire_after         = optional(string, null)<br>      notify_before_expiry = optional(string, null)<br>    }), null)<br>    tags = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_recovery_services_vault"></a> [recovery\_services\_vault](#input\_recovery\_services\_vault) | Configuration object for Azure Recovery Services Vault | <pre>object({<br>    name                             = string<br>    public_network_access_enabled    = optional(bool, false)<br>    sku                              = optional(string, "Standard")<br>    storage_mode_type                = optional(string, "ZoneRedundant")<br>    soft_delete_enabled              = optional(bool, true)<br>    immutability                     = optional(bool, null)<br>    cmk_encryption_enabled           = optional(bool, false)<br>    cmk_identity                     = optional(string, null)<br>    cmk_key_vault_key_id             = optional(string, null)<br>    system_assigned_identity_enabled = optional(bool, false)<br>    user_assigned_resource_ids       = optional(set(string), [])<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cmkrsa_id"></a> [cmkrsa\_id](#output\_cmkrsa\_id) | CMK RSA Key ID |
| <a name="output_cmkrsa_key_name"></a> [cmkrsa\_key\_name](#output\_cmkrsa\_key\_name) | CMK RSA Key Name |
| <a name="output_cmkrsa_resource_resource_id"></a> [cmkrsa\_resource\_resource\_id](#output\_cmkrsa\_resource\_resource\_id) | CMK RSA Key Resource ID |
| <a name="output_cmkrsa_resource_versionless_id"></a> [cmkrsa\_resource\_versionless\_id](#output\_cmkrsa\_resource\_versionless\_id) | CMK RSA Key ID |
| <a name="output_cmkrsa_versionless_id"></a> [cmkrsa\_versionless\_id](#output\_cmkrsa\_versionless\_id) | CMK RSA Key ID |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
| <a name="output_recovery_services_vault_id"></a> [recovery\_services\_vault\_id](#output\_recovery\_services\_vault\_id) | The Recovery Services Vault ID |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | n/a |
<!-- END_TF_DOCS -->