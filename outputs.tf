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
  value = module.recovery_services_vault.recovery_services_vault_id
  description = "The Recovery Services "
}