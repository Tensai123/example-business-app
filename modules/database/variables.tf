# Required variables from Terragrunt root
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "component" {
  description = "Component name (extracted from path)"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
}

variable "naming_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "naming_separator" {
  description = "Separator for resource naming"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  sensitive   = true
}

# Dependencies from other modules
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

# SQL Server configuration
variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string

  validation {
    condition     = length(var.sql_server_name) >= 1 && length(var.sql_server_name) <= 63
    error_message = "SQL Server name must be between 1 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.sql_server_name))
    error_message = "SQL Server name must start and end with alphanumeric characters and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "sql_server_version" {
  description = "Version of SQL Server to use"
  type        = string
  default     = "12.0"

  validation {
    condition     = contains(["12.0"], var.sql_server_version)
    error_message = "SQL Server version must be 12.0 (SQL Server 2014 or later)."
  }
}

variable "sql_admin_username" {
  description = "Administrator username for SQL Server"
  type        = string

  validation {
    condition     = length(var.sql_admin_username) >= 1 && length(var.sql_admin_username) <= 128
    error_message = "SQL admin username must be between 1 and 128 characters."
  }

  validation {
    condition     = !contains(["admin", "administrator", "sa", "root", "dbmanager", "loginmanager", "dbo", "guest", "public"], lower(var.sql_admin_username))
    error_message = "SQL admin username cannot be a reserved name."
  }
}

variable "sql_admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.sql_admin_password) >= 8 && length(var.sql_admin_password) <= 128
    error_message = "SQL admin password must be between 8 and 128 characters."
  }
}

# Database configuration
variable "database_name" {
  description = "Name of the SQL Database"
  type        = string

  validation {
    condition     = length(var.database_name) >= 1 && length(var.database_name) <= 128
    error_message = "Database name must be between 1 and 128 characters."
  }
}

variable "database_collation" {
  description = "Collation of the database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "License type for the database"
  type        = string
  default     = "LicenseIncluded"

  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "License type must be either 'LicenseIncluded' or 'BasePrice'."
  }
}

variable "database_sku_name" {
  description = "SKU name for the database"
  type        = string
  default     = "Basic"

  validation {
    condition = can(regex("^(Basic|S[0-9]+|P[0-9]+|GP_|BC_|HS_)", var.database_sku_name))
    error_message = "Database SKU must be a valid Azure SQL Database SKU (Basic, Standard, Premium, or vCore-based)."
  }
}

variable "zone_redundant" {
  description = "Enable zone redundancy for the database"
  type        = bool
  default     = false
}

# Security settings
variable "minimum_tls_version" {
  description = "Minimum TLS version for connections"
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2."
  }
}

variable "public_network_access_enabled" {
  description = "Enable public network access to SQL Server"
  type        = bool
  default     = true
}

variable "outbound_network_restriction_enabled" {
  description = "Enable outbound network restriction"
  type        = bool
  default     = false
}

# Backup settings
variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "Backup retention days must be between 7 and 35."
  }
}

variable "weekly_retention" {
  description = "Weekly backup retention period"
  type        = string
  default     = "P1W"
}

variable "monthly_retention" {
  description = "Monthly backup retention period"
  type        = string
  default     = "P1M"
}

variable "yearly_retention" {
  description = "Yearly backup retention period"
  type        = string
  default     = "P1Y"
}

variable "week_of_year" {
  description = "Week of year for yearly backup"
  type        = number
  default     = 1

  validation {
    condition     = var.week_of_year >= 1 && var.week_of_year <= 52
    error_message = "Week of year must be between 1 and 52."
  }
}

# Threat detection
variable "enable_threat_detection" {
  description = "Enable Advanced Threat Protection"
  type        = bool
  default     = false
}

variable "threat_detection_emails" {
  description = "List of email addresses for threat detection alerts"
  type        = list(string)
  default     = []
}

variable "threat_detection_retention_days" {
  description = "Number of days to retain threat detection logs"
  type        = number
  default     = 0

  validation {
    condition     = var.threat_detection_retention_days >= 0 && var.threat_detection_retention_days <= 3285
    error_message = "Threat detection retention days must be between 0 and 3285."
  }
}

# Network access
variable "allow_azure_services" {
  description = "Allow Azure services to access the SQL Server"
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "Map of allowed IP ranges"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access the SQL Server"
  type        = list(string)
  default     = []
}

variable "ignore_missing_vnet_service_endpoint" {
  description = "Ignore missing VNet service endpoint"
  type        = bool
  default     = true
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs"
  type        = list(string)
  default     = []
}

# Additional integration outputs
variable "key_vault_password_secret_id" {
  description = "Key Vault secret ID containing the SQL admin password"
  type        = string
  default     = ""
}