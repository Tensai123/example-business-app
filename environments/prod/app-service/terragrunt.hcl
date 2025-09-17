# Include the root Terragrunt configuration
include "root" {
  path = find_in_parent_folders()
}

# Dependencies - ALL previous modules
dependency "resource_group" {
  config_path = "../resource-group"
  
  mock_outputs = {
    resource_group_name = "poc-rg-prod"
    location           = "West Europe"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

dependency "networking" {
  config_path = "../networking"
  
  mock_outputs = {
    vnet_id                = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.Network/virtualNetworks/poc-prod-vnet"
    app_service_subnet_id  = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.Network/virtualNetworks/poc-prod-vnet/subnets/snet-app-service"
    database_subnet_id     = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.Network/virtualNetworks/poc-prod-vnet/subnets/snet-database"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

dependency "security" {
  config_path = "../security"
  
  mock_outputs = {
    key_vault_id                      = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.KeyVault/vaults/poc-prod-kv-12345"
    key_vault_name                    = "poc-prod-kv-12345"
    key_vault_uri                     = "https://poc-prod-kv-12345.vault.azure.net/"
    sql_admin_password_secret_id      = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.KeyVault/vaults/poc-prod-kv-12345/secrets/sql-server-admin-password"
    key_vault_reference_sql_password  = "@Microsoft.KeyVault(VaultName=poc-prod-kv-12345;SecretName=sql-server-admin-password)"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

dependency "database" {
  config_path = "../database"
  
  mock_outputs = {
    sql_server_id                    = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.Sql/servers/poc-prod-sqlsrv-12345"
    sql_server_name                  = "poc-prod-sqlsrv-12345"
    sql_server_fqdn                  = "poc-prod-sqlsrv-12345.database.windows.net"
    database_id                      = "/subscriptions/mock/resourceGroups/poc-rg-prod/providers/Microsoft.Sql/servers/poc-prod-sqlsrv-12345/databases/poc-prod-db"
    database_name                    = "poc-prod-db"
    connection_string_no_password    = "Server=tcp:poc-prod-sqlsrv-12345.database.windows.net,1433;Initial Catalog=poc-prod-db;Persist Security Info=False;User ID=sqladmin;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    sql_admin_username               = "sqladmin"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

# Specify the Terraform module source
terraform {
  source = "../../../modules//app-service"
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]

    arguments = [
      "-var-file=${get_terragrunt_dir()}/terraform.tfvars"
    ]
  }
}

# Pass dependency outputs as inputs
inputs = {
  # Dependencies from resource group
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location           = dependency.resource_group.outputs.location
  
  # Dependencies from networking (VNet integration)
  vnet_integration_subnet_id = dependency.networking.outputs.app_service_subnet_id
  
  # Dependencies from database (connection string will be in terraform.tfvars)
  sql_server_fqdn        = dependency.database.outputs.sql_server_fqdn
  database_name          = dependency.database.outputs.database_name  
  sql_admin_username     = dependency.database.outputs.sql_admin_username
  key_vault_password_reference = dependency.security.outputs.key_vault_reference_sql_password
}