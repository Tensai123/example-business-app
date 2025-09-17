terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Azure SQL Server
resource "azurerm_mssql_server" "main" {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.sql_server_version

  # Authentication
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  # Security settings
  minimum_tls_version               = var.minimum_tls_version
  public_network_access_enabled     = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled

  # System assigned identity for accessing other Azure services
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

# Azure SQL Database
resource "azurerm_mssql_database" "main" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.main.id
  collation      = var.database_collation
  license_type   = var.license_type
  sku_name       = var.database_sku_name
  zone_redundant = var.zone_redundant

  # Backup settings
  short_term_retention_policy {
    retention_days = var.backup_retention_days
  }

  long_term_retention_policy {
    weekly_retention  = var.weekly_retention
    monthly_retention = var.monthly_retention
    yearly_retention  = var.yearly_retention
    week_of_year      = var.week_of_year
  }

  # Threat detection
  threat_detection_policy {
    state           = var.enable_threat_detection ? "Enabled" : "Disabled"
    email_addresses = var.threat_detection_emails
    retention_days  = var.threat_detection_retention_days
  }

  tags = var.common_tags
}

# Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "azure_services" {
  count = var.allow_azure_services ? 1 : 0

  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall rules for specific IP ranges
resource "azurerm_mssql_firewall_rule" "allowed_ips" {
  for_each = var.allowed_ip_ranges

  name             = "AllowIP-${each.key}"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}

# VNet rules for subnet access
resource "azurerm_mssql_virtual_network_rule" "vnet_rules" {
  for_each = toset(var.allowed_subnet_ids)

  name      = "vnet-rule-${replace(split("/", each.key)[10], "-", "")}"
  server_id = azurerm_mssql_server.main.id
  subnet_id = each.key

  # Ignore missing VNet service endpoint
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
}