output "key_vault_id" {
  value = module.keyvault_with_cmk.key_vault_id
}

output "key_vault_name" {
  value = module.keyvault_with_cmk.key_vault_name
}

output "key_vault_uri" {
  value = module.keyvault_with_cmk.key_vault_uri
}

output "cmkrsa_key_name" {
  value       = module.keyvault_with_cmk.cmkrsa_key_name
  description = "CMK RSA Key Name"
}

output "cmkrsa_id" {
  value       = module.keyvault_with_cmk.cmkrsa_id
  description = "CMK RSA Key ID"
}

output "cmkrsa_versionless_id" {
  value       = module.keyvault_with_cmk.cmkrsa_versionless_id
  description = "CMK RSA Key ID"
}

output "cmkrsa_resource_versionless_id" {
  value       = module.keyvault_with_cmk.cmkrsa_resource_versionless_id
  description = "CMK RSA Key ID"
}

output "cmkrsa_resource_resource_id" {
  value       = module.keyvault_with_cmk.cmkrsa_resource_resource_id
  description = "CMK RSA Key Resource ID"
}

output "recovery_services_vault_id" {
  value       = var.recovery_services_vault != null ? module.recovery_services_vault[0].recovery_services_vault_id : null
  description = "The Recovery Services Vault ID"
}

output "storage_account_id" {
  value = var.boot_diag_storage_account != null ? module.boot_diag_storage_account[0].id : null
}

output "container_registry_id" {
  value = var.container_registry != null ? module.container_registry[0].resource_id : null
}

output "resource_group_id" {
  value       = azurerm_resource_group.this.id
  description = "ID of the Resource Group created by the module"
}
