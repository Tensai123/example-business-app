# Basic required variables
variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "web_app_name" {
  description = "Name of the Web App"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "os_type" {
  description = "OS type"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "SKU name"
  type        = string
  default     = "B1"
}

# Security settings
variable "https_only" {
  description = "HTTPS only"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Public network access"
  type        = bool
  default     = true
}

# Database connection
variable "sql_server_fqdn" {
  description = "SQL Server FQDN"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL admin username"
  type        = string
}

variable "key_vault_password_reference" {
  description = "Key Vault password reference"
  type        = string
}

# Site config
variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "ftps_state" {
  description = "FTPS state"
  type        = string
  default     = "Disabled"
}

variable "python_version" {
  description = "Python version"
  type        = string
  default     = "3.11"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/health"
}

variable "health_check_eviction_time_in_min" {
  description = "Health check eviction time"
  type        = number
  default     = 2
}

# VNet Integration
variable "enable_vnet_integration" {
  description = "Enable VNet integration for secure communication"
  type        = bool
  default     = false
}

variable "vnet_integration_subnet_id" {
  description = "Subnet ID for VNet integration (App Service subnet)"
  type        = string
  default     = null
}

# Common tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}