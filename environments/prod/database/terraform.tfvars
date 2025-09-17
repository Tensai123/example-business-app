# SQL Server configuration
sql_server_name    = "poc-prod-sqlsrv-12345"  # Must be globally unique
sql_server_version = "12.0"

# Authentication
sql_admin_username = "sqladmin"
# sql_admin_password comes from dependency (Key Vault)

# Database configuration
database_name      = "poc-prod-db"
database_collation = "SQL_Latin1_General_CP1_CI_AS"
license_type       = "LicenseIncluded"
database_sku_name  = "S2"  # Dev: Basic | Staging: S1 | Prod: S2+
zone_redundant     = true    # Dev: false | Prod: true

# Security settings (dev - more permissive)
minimum_tls_version                   = "1.2"
public_network_access_enabled         = false   # Dev: true | Prod: false
outbound_network_restriction_enabled  = false  # Dev: false | Prod: true

# Backup settings (dev - minimal)
backup_retention_days = 35      # Dev: 7 | Prod: 35
weekly_retention     = "P1W"   # 1 week
monthly_retention    = "P1M"   # 1 month  
yearly_retention     = "P1Y"   # 1 year
week_of_year         = 1

# Threat detection (dev - disabled for cost)
enable_threat_detection           = true  # Dev: false | Prod: true
threat_detection_emails          = []
threat_detection_retention_days  = 0

# Network access settings
allow_azure_services = true

# Allowed IP ranges (dev - your IP for testing)
allowed_ip_ranges = {
  # "your-ip" = {
  #   start_ip = "1.2.3.4"
  #   end_ip   = "1.2.3.4" 
  # }
}

# VNet rules settings
ignore_missing_vnet_service_endpoint = true

# Private endpoint (dev - disabled for simplicity)
enable_private_endpoint = false
private_dns_zone_ids   = []

# Optional features
enable_diagnostics  = false  # Dev: false | Prod: true
log_analytics_workspace_id = null