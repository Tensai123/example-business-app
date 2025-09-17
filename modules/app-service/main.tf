terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "main" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  # Security settings
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLServer"
    value = "Server=tcp:${var.sql_server_fqdn},1433;Initial Catalog=${var.database_name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.key_vault_password_reference};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  site_config {
    # Runtime settings
    minimum_tls_version = var.minimum_tls_version
    ftps_state         = var.ftps_state

    # Application stack
    application_stack {
      python_version = var.python_version
    }

    health_check_path                 = var.health_check_path
    health_check_eviction_time_in_min = var.health_check_eviction_time_in_min
  }

  # Managed Identity for Key Vault access
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

# VNet Integration for secure communication with database
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  count = var.enable_vnet_integration ? 1 : 0

  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = var.vnet_integration_subnet_id
}