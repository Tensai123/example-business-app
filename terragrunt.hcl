locals {
  # Parse the file path to extract environment and component
  path_parts = split("/", path_relative_to_include())
  environment = length(local.path_parts) > 1 ? local.path_parts[1] : "unknown"
  component   = length(local.path_parts) > 2 ? local.path_parts[2] : "unknown"

  # Backend configuration based on environment
  backend_config = {
    resource_group_name  = get_env("TFSTATE_RESOURCE_GROUP")
    storage_account_name = get_env("TFSTATE_STORAGE_ACCOUNT")
    container_name       = get_env("TFSTATE_CONTAINER")
    key                  = "${local.environment}/${local.component}.tfstate"
  }
  
  # Common tags for all resources
  common_tags = {
    ManagedBy    = "Terragrunt"
    Project      = "Azure-PoC"
    Repository   = "terraform-azure-poc"
    Environment  = title(local.environment)
    Component    = local.component
    DeployedAt   = timestamp()
    DeployedBy   = get_env("BUILD_REQUESTEDFOR", get_env("USER", "unknown"))
  }

  # Common naming convention
  naming = {
    separator = "-"
    prefix    = "poc"
  }
}

remote_state {
  backend = "azurerm"
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  
  config = local.backend_config
}

generate "provider" {
    path      = "providers.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "azurerm" {
    features {}
}
EOF
}

inputs = {
  # Global configuration
  environment   = local.environment
  component     = local.component
  common_tags   = local.common_tags
  
  # Azure configuration
  subscription_id = get_env("ARM_SUBSCRIPTION_ID")
  tenant_id      = get_env("ARM_TENANT_ID")
  
  # Naming convention
  naming_separator = local.naming.separator
  naming_prefix    = local.naming.prefix
}