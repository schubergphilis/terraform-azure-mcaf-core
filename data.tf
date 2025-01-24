data "azurerm_user_assigned_identity" "this" {
  count = var.recovery_service_vault.cmk_encryption_enabled == null ? 0 : (var.recovery_service_vault.cmk_identity != null ? 1 : 0)

  name                = provider::azurerm::parse_resource_id(var.customer_managed_key.user_assigned_identity.resource_id)["resource_name"]
  resource_group_name = provider::azurerm::parse_resource_id(var.customer_managed_key.user_assigned_identity.resource_id)["resource_group_name"]
}
