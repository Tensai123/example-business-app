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

# Key Vault configuration
variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string

  validation {
    condition     = length(var.key_vault_name) >= 3 && length(var.key_vault_name) <= 24
    error_message = "Key Vault name must be between 3 and 24 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.key_vault_name))
    error_message = "Key Vault name must start with a letter, end with a letter or number, and contain only letters, numbers, and hyphens."
  }
}

variable "key_vault_sku" {
  description = "SKU name for Key Vault"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be either 'standard' or 'premium'."
  }
}

# Key Vault features
variable "enable_disk_encryption" {
  description = "Enable Key Vault for disk encryption"
  type        = bool
  default     = false
}

variable "enable_deployment" {
  description = "Enable Key Vault for Azure Resource Manager deployment"
  type        = bool
  default     = false
}

variable "enable_template_deployment" {
  description = "Enable Key Vault for ARM template deployment"
  type        = bool
  default     = false
}

variable "enable_purge_protection" {
  description = "Enable purge protection (cannot be disabled once enabled)"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted items"
  type        = number
  default     = 7

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

# Network access configuration
variable "public_network_access_enabled" {
  description = "Enable public network access to Key Vault"
  type        = bool
  default     = true
}

variable "default_network_action" {
  description = "Default network action for Key Vault network ACLs"
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Allow", "Deny"], var.default_network_action)
    error_message = "Default network action must be either 'Allow' or 'Deny'."
  }
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access Key Vault"
  type        = list(string)
  default     = []
}

# Access policies
variable "admin_object_ids" {
  description = "Object IDs of Key Vault administrators"
  type        = list(string)
  default     = []
}

# Application secrets (individual variables to avoid for_each with sensitive)
variable "app_insights_connection_string" {
  description = "Application Insights connection string"
  type        = string
  default     = null
  sensitive   = true
}

variable "storage_connection_string" {
  description = "Storage account connection string"
  type        = string
  default     = null
  sensitive   = true
}

variable "api_key_external" {
  description = "External API key"
  type        = string
  default     = null
  sensitive   = true
}