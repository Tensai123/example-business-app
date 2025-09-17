# Include the root Terragrunt configuration
include "root" {
  path = find_in_parent_folders()
}

# Dependencies
dependency "resource_group" {
  config_path = "../resource-group"
  
  mock_outputs = {
    resource_group_name = "poc-rg-dev"
    resource_group_id   = "/subscriptions/mock/resourceGroups/poc-rg-dev"
    location           = "West Europe"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

dependency "networking" {
  config_path = "../networking"
  
  mock_outputs = {
    vnet_id                = "/subscriptions/mock/resourceGroups/poc-rg-dev/providers/Microsoft.Network/virtualNetworks/poc-dev-vnet"
    app_service_subnet_id  = "/subscriptions/mock/resourceGroups/poc-rg-dev/providers/Microsoft.Network/virtualNetworks/poc-dev-vnet/subnets/snet-app-service"
    database_subnet_id     = "/subscriptions/mock/resourceGroups/poc-rg-dev/providers/Microsoft.Network/virtualNetworks/poc-dev-vnet/subnets/snet-database"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

# Specify the Terraform module source
terraform {
  source = "../../../modules//security"
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
  resource_group_id   = dependency.resource_group.outputs.resource_group_id
  location           = dependency.resource_group.outputs.location
  
  # Dependencies from networking (for Key Vault network ACLs)
  allowed_subnet_ids = [
    dependency.networking.outputs.app_service_subnet_id,
    dependency.networking.outputs.database_subnet_id
  ]
}