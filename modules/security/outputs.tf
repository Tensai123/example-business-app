# Key Vault outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_tenant_id" {
  description = "Tenant ID associated with the Key Vault"
  value       = azurerm_key_vault.main.tenant_id
}

# Secret outputs (references, not values)
output "sql_admin_password_secret_id" {
  description = "Key Vault secret ID for SQL admin password"
  value       = azurerm_key_vault_secret.sql_admin_password.id
}

output "sql_admin_password_secret_name" {
  description = "Key Vault secret name for SQL admin password"
  value       = azurerm_key_vault_secret.sql_admin_password.name
}

output "sql_admin_password_value" {
  description = "Generated SQL admin password (sensitive)"
  value       = random_password.sql_admin_password.result
  sensitive   = true
}

output "application_secret_ids" {
  description = "Map of application secret names to their Key Vault secret IDs"
  value = {
    app_insights_connection_string = var.app_insights_connection_string != null ? azurerm_key_vault_secret.app_insights_connection_string[0].id : null
    storage_connection_string      = var.storage_connection_string != null ? azurerm_key_vault_secret.storage_connection_string[0].id : null
    api_key_external              = var.api_key_external != null ? azurerm_key_vault_secret.api_key_external[0].id : null
  }
  sensitive = true
}

# Key Vault references for other modules
output "key_vault_reference_sql_password" {
  description = "Key Vault reference for SQL password (for use in connection strings)"
  value       = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=${azurerm_key_vault_secret.sql_admin_password.name})"
}

# Access policy outputs
output "terraform_principal_object_id" {
  description = "Object ID of the Terraform service principal"
  value       = data.azurerm_client_config.current.object_id
}

output "key_vault_access_policy_ids" {
  description = "IDs of Key Vault access policies"
  value = {
    terraform_principal = azurerm_key_vault_access_policy.terraform_principal.id
    admins = var.admin_object_ids != null ? azurerm_key_vault_access_policy.key_vault_admins[*].id : []
  }
}