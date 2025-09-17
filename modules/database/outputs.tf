# SQL Server outputs
output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_server_version" {
  description = "Version of the SQL Server"
  value       = azurerm_mssql_server.main.version
}

output "sql_server_identity_principal_id" {
  description = "Principal ID of the SQL Server managed identity"
  value       = azurerm_mssql_server.main.identity[0].principal_id
}

output "sql_server_identity_tenant_id" {
  description = "Tenant ID of the SQL Server managed identity"
  value       = azurerm_mssql_server.main.identity[0].tenant_id
}

# Database outputs
output "database_id" {
  description = "ID of the SQL Database"
  value       = azurerm_mssql_database.main.id
}

output "database_name" {
  description = "Name of the SQL Database"
  value       = azurerm_mssql_database.main.name
}

output "database_collation" {
  description = "Collation of the SQL Database"
  value       = azurerm_mssql_database.main.collation
}

output "database_sku_name" {
  description = "SKU name of the SQL Database"
  value       = azurerm_mssql_database.main.sku_name
}

# Connection string outputs
output "connection_string" {
  description = "ADO.NET connection string for the database"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "connection_string_no_password" {
  description = "ADO.NET connection string template (without password)"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.sql_admin_username};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

output "connection_string_with_keyvault" {
  description = "Connection string using Key Vault reference"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=@Microsoft.KeyVault(VaultName=${split("/", var.key_vault_password_secret_id)[4]};SecretName=${split("/", var.key_vault_password_secret_id)[5]});MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

# Network access outputs
output "firewall_rule_ids" {
  description = "IDs of the firewall rules"
  value = {
    azure_services = var.allow_azure_services ? azurerm_mssql_firewall_rule.azure_services[0].id : null
    allowed_ips    = { for k, v in azurerm_mssql_firewall_rule.allowed_ips : k => v.id }
  }
}

output "vnet_rule_ids" {
  description = "IDs of the VNet rules"
  value       = { for k, v in azurerm_mssql_virtual_network_rule.vnet_rules : k => v.id }
}

# Authentication outputs (for integration with other modules)
output "sql_admin_username" {
  description = "SQL Server administrator username"
  value       = var.sql_admin_username
}