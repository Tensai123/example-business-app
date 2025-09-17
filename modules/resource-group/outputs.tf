output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "tags" {
  description = "Tags applied to the resource group"
  value       = azurerm_resource_group.main.tags
}

output "resource_group_lock_id" {
  description = "ID of the resource group management lock (if enabled)"
  value       = var.enable_resource_lock ? azurerm_management_lock.resource_group_lock[0].id : null
}