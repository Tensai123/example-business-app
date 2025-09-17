terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

# Optional: Management lock to prevent accidental deletion
resource "azurerm_management_lock" "resource_group_lock" {
  count = var.enable_resource_lock ? 1 : 0
  
  name       = "${var.resource_group_name}-lock"
  scope      = azurerm_resource_group.main.id
  lock_level = var.lock_level
  notes      = "Terragrunt managed resource group lock"

  depends_on = [azurerm_resource_group.main]
}