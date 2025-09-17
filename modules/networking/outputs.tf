# VNet outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "vnet_location" {
  description = "Location of the virtual network"
  value       = azurerm_virtual_network.main.location
}

# App Service subnet outputs
output "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  value       = azurerm_subnet.app_service.id
}

output "app_service_subnet_name" {
  description = "Name of the App Service subnet"
  value       = azurerm_subnet.app_service.name
}

output "app_service_subnet_address_prefixes" {
  description = "Address prefixes of the App Service subnet"
  value       = azurerm_subnet.app_service.address_prefixes
}

# Database subnet outputs
output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database.id
}

output "database_subnet_name" {
  description = "Name of the database subnet"
  value       = azurerm_subnet.database.name
}

output "database_subnet_address_prefixes" {
  description = "Address prefixes of the database subnet"
  value       = azurerm_subnet.database.address_prefixes
}

# Network Security Group outputs
output "app_service_nsg_id" {
  description = "ID of the App Service Network Security Group"
  value       = var.enable_app_service_nsg ? azurerm_network_security_group.app_service[0].id : null
}

output "app_service_nsg_name" {
  description = "Name of the App Service Network Security Group"
  value       = var.enable_app_service_nsg ? azurerm_network_security_group.app_service[0].name : null
}

output "database_nsg_id" {
  description = "ID of the database Network Security Group"
  value       = var.enable_database_nsg ? azurerm_network_security_group.database[0].id : null
}

output "database_nsg_name" {
  description = "Name of the database Network Security Group"
  value       = var.enable_database_nsg ? azurerm_network_security_group.database[0].name : null
}

# Hub peering output (if enabled)
output "hub_peering_id" {
  description = "ID of the hub VNet peering"
  value       = var.hub_vnet_id != null ? azurerm_virtual_network_peering.hub_peering[0].id : null
}