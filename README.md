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
| <a name="module_keyvault_with_cmk"></a> [keyvault\_with\_cmk](#module\_keyvault\_with\_cmk) | github.com/schubergphilis/terraform-azure-mcaf-key-vault.git | v0.3.1 |
| <a name="module_recovery_services_vault"></a> [recovery\_services\_vault](#module\_recovery\_services\_vault) | github.com/schubergphilis/terraform-azure-mcaf-recovery-vault.git | v0.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | n/a | <pre>object({<br>    name                            = string<br>    enabled_for_disk_encryption     = optional(bool, false)<br>    enabled_for_deployment          = optional(bool, false)<br>    enabled_for_template_deployment = optional(bool, false)<br>    enable_rbac_authorization       = optional(bool, true)<br>    purge_protection                = optional(bool, true)<br>    soft_delete_retention_days      = optional(number, 30)<br>    sku                             = optional(string, "standard")<br>    public_network_access_enabled   = optional(bool, false)<br>    ip_rules                        = optional(list(string), [])<br>    subnet_ids                      = optional(list(string), [])<br>    network_bypass                  = optional(string, "None")<br>    cmk_keys_create                 = optional(bool, true)<br>    cmkrsa_key_name                 = optional(string, "cmkrsa")<br>    cmkec_key_name                  = optional(string, "cmkec")<br>    cmk_rotation_period             = optional(string, "P18M")<br>    cmk_expiry_period               = optional(string, "P2Y")<br>    cmk_notify_period               = optional(string, "P30D")<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resources to create | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the resources. | `string` | n/a | yes |
| <a name="input_recovery_services_vault"></a> [recovery\_services\_vault](#input\_recovery\_services\_vault) | Configuration object for Azure Recovery Services Vault | <pre>object({<br>    name                             = string<br>    public_network_access_enabled    = optional(bool, false)<br>    sku                              = optional(string, "Standard")<br>    storage_mode_type                = optional(string, "ZoneRedundant")<br>    soft_delete_enabled              = optional(bool, true)<br>    immutability                     = optional(bool, null)<br>    cmk_encryption_enabled           = optional(bool, false)<br>    cmk_identity                     = optional(string, null)<br>    cmk_key_vault_key_id             = optional(string, null)<br>    system_assigned_identity_enabled = optional(bool, false)<br>    user_assigned_resource_ids       = optional(list(string), [])<br>  })</pre> | `null` | no |
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
<!-- END_TF_DOCS -->