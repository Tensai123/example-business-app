# Include the root Terragrunt configuration
include "root" {
  path = find_in_parent_folders()
}

# Dependency on resource group
dependency "resource_group" {
  config_path = "../resource-group"
  
  # Mock outputs for planning when dependency hasn't been applied yet
  mock_outputs = {
    resource_group_name = "poc-rg-dev"
    resource_group_id   = "/subscriptions/mock/resourceGroups/poc-rg-dev"
    location           = "West Europe"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
}

# Specify the Terraform module source
terraform {
  source = "../../../modules//networking"
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

# Pass dependency outputs as inputs (these override .tfvars)
inputs = {
  # Dependencies from resource group component
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  resource_group_id   = dependency.resource_group.outputs.resource_group_id
  location           = dependency.resource_group.outputs.location
}