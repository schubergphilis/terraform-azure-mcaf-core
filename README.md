# terraform-azure-mcaf-core
Terraform module to create the Core component of each workload, currently only implements Terraform-azure-mcaf-key-vault

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_keyvault_with_cmk"></a> [keyvault\_with\_cmk](#module\_keyvault\_with\_cmk) | github.com/schubergphilis/terraform-azure-mcaf-key-vault.git | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | n/a | <pre>object({<br>    name                            = string<br>    enabled_for_disk_encryption     = optional(bool, false)<br>    enabled_for_deployment          = optional(bool, false)<br>    enabled_for_template_deployment = optional(bool, false)<br>    enable_rbac_authorization       = optional(bool, true)<br>    purge_protection                = optional(bool, true)<br>    soft_delete_retention_days      = optional(number, 30)<br>    sku                             = optional(string, "standard")<br>    ip_rules                        = optional(list(string), [])<br>    subnet_ids                      = optional(list(string), [])<br>    network_bypass                  = optional(string, "None")<br>    cmk_keys_create                 = optional(bool, true)<br>    cmkrsa_key_name                 = optional(string, "cmkrsa")<br>    cmkec_key_name                  = optional(string, "cmkec")<br>    cmk_rotation_period             = optional(string, "P90D")<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resources to create | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group in which to create the resources. | <pre>object({<br>    name = string<br>  })</pre> | <pre>{<br>  "name": null<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of availability zones in which the resource should be created. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_cmkrsa_id"></a> [key\_vault\_cmkrsa\_id](#output\_key\_vault\_cmkrsa\_id) | CMK RSA Key ID |
| <a name="output_key_vault_cmkrsa_key_name"></a> [key\_vault\_cmkrsa\_key\_name](#output\_key\_vault\_cmkrsa\_key\_name) | CMK RSA Key Name |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
<!-- END_TF_DOCS -->