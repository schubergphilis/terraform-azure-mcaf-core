output "key_vault_id" {
  value = module.keyvault_with_cmk.key_vault_id
}

output "key_vault_name" {
  value = module.keyvault_with_cmk.key_vault_name
}

output "key_vault_uri" {
  value = module.keyvault_with_cmk.key_vault_uri
}

output "key_vault_cmkrsa_key_name" {
  value       = module.keyvault_with_cmk.key_vault_cmkrsa_keyname
  description = "CMK RSA Key Name"
}

output "key_vault_cmkrsa_id" {
  value       = module.keyvault_with_cmk.key_vault_cmkrsa_id
  description = "CMK RSA Key ID"
}
