# Basic outputs
output "web_app_name" {
  description = "Web App name"
  value       = azurerm_linux_web_app.main.name
}

output "web_app_id" {
  description = "Web App ID"
  value       = azurerm_linux_web_app.main.id
}

output "web_app_default_hostname" {
  description = "Default hostname"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "web_app_url" {
  description = "Web App URL"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

# App Service Plan outputs
output "app_service_plan_id" {
  description = "App Service Plan ID"
  value       = azurerm_service_plan.main.id
}

output "app_service_plan_name" {
  description = "App Service Plan name"
  value       = azurerm_service_plan.main.name
}

# Managed Identity outputs
output "web_app_identity_principal_id" {
  description = "Principal ID of the Web App managed identity"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "web_app_identity_tenant_id" {
  description = "Tenant ID of the Web App managed identity"
  value       = azurerm_linux_web_app.main.identity[0].tenant_id
}

# VNet Integration outputs
output "vnet_integration_id" {
  description = "VNet integration ID"
  value       = var.enable_vnet_integration ? azurerm_app_service_virtual_network_swift_connection.main[0].id : null
}

# Helper outputs for other modules
output "app_service_principal_id" {
  description = "Principal ID for Key Vault access policies (alias)"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "app_service_outbound_ip_addresses" {
  description = "Outbound IP addresses for firewall rules"
  value       = split(",", azurerm_linux_web_app.main.outbound_ip_addresses)
}