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

# Module-specific required variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._\\(\\)-]+$", var.resource_group_name))
    error_message = "Resource group name can only contain alphanumeric characters, periods, parentheses, hyphens, and underscores."
  }
}

variable "location" {
  description = "Azure region where the resource group will be created"
  type        = string

  validation {
    condition = contains([
      "East US", "East US 2", "South Central US", "West US 2", "West US 3",
      "Australia East", "Southeast Asia", "North Europe", "Sweden Central",
      "UK South", "West Europe", "Central US", "North Central US", "West US",
      "South Africa North", "Central India", "East Asia", "Japan East",
      "Korea Central", "Canada Central", "France Central", "Germany West Central",
      "Norway East", "Poland Central", "Switzerland North", "UAE North",
      "Brazil South", "East US 2 EUAP", "Qatar Central"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

# Module-specific optional variables
variable "enable_resource_lock" {
  description = "Enable management lock on the resource group"
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Level of management lock (CanNotDelete or ReadOnly)"
  type        = string
  default     = "CanNotDelete"

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "Lock level must be either 'CanNotDelete' or 'ReadOnly'."
  }
}