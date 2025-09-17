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
  default     = "West Europe"
}

# VNet configuration
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string

  validation {
    condition     = length(var.vnet_name) >= 2 && length(var.vnet_name) <= 64
    error_message = "VNet name must be between 2 and 64 characters."
  }
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)

  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "At least one address space must be specified."
  }

  validation {
    condition = alltrue([
      for addr in var.vnet_address_space : can(cidrhost(addr, 0))
    ])
    error_message = "All address spaces must be valid CIDR blocks."
  }
}

# App Service subnet configuration
variable "app_service_subnet_name" {
  description = "Name of the App Service subnet"
  type        = string
  default     = "snet-app-service"

  validation {
    condition     = length(var.app_service_subnet_name) >= 1 && length(var.app_service_subnet_name) <= 80
    error_message = "Subnet name must be between 1 and 80 characters."
  }
}

variable "app_service_subnet_prefix" {
  description = "Address prefix for App Service subnet"
  type        = list(string)

  validation {
    condition = alltrue([
      for addr in var.app_service_subnet_prefix : can(cidrhost(addr, 0))
    ])
    error_message = "All subnet prefixes must be valid CIDR blocks."
  }
}

# Database subnet configuration
variable "database_subnet_name" {
  description = "Name of the database subnet"
  type        = string
  default     = "snet-database"

  validation {
    condition     = length(var.database_subnet_name) >= 1 && length(var.database_subnet_name) <= 80
    error_message = "Subnet name must be between 1 and 80 characters."
  }
}

variable "database_subnet_prefix" {
  description = "Address prefix for database subnet"
  type        = list(string)

  validation {
    condition = alltrue([
      for addr in var.database_subnet_prefix : can(cidrhost(addr, 0))
    ])
    error_message = "All subnet prefixes must be valid CIDR blocks."
  }
}

# Network Security Group configuration
variable "enable_app_service_nsg" {
  description = "Enable Network Security Group for App Service subnet"
  type        = bool
  default     = true
}

variable "enable_database_nsg" {
  description = "Enable Network Security Group for database subnet"
  type        = bool
  default     = true
}

variable "allow_internet_outbound" {
  description = "Allow outbound internet access from App Service subnet"
  type        = bool
  default     = true
}

# Optional features
variable "enable_ddos_protection" {
  description = "Enable DDoS protection standard"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable NSG flow logs"
  type        = bool
  default     = false
}

# Hub-spoke networking (optional)
variable "hub_vnet_id" {
  description = "ID of hub VNet for peering (optional)"
  type        = string
  default     = null
}

variable "use_hub_gateway" {
  description = "Use gateway from hub VNet"
  type        = bool
  default     = false
}

# DNS configuration (optional)
variable "dns_servers" {
  description = "Custom DNS servers for the VNet"
  type        = list(string)
  default     = []
}